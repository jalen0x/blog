module SeoHelper
  SITE_NAME = "Jalen's Blog".freeze
  SITE_DESCRIPTION = "A Rails engineer's thoughts on building products, technical exploration, and software development.".freeze
  DEFAULT_OG_IMAGE = "/og-image.png".freeze
  TWITTER_HANDLE = "@jalen0x_".freeze
  SITE_URL = "https://jalenx.me".freeze

  def page_title(title = nil)
    if title.present?
      "#{title} | #{SITE_NAME}"
    else
      SITE_NAME
    end
  end

  def meta_description(description = nil)
    (description.presence || SITE_DESCRIPTION).truncate(160)
  end

  def canonical_url(path = nil)
    path.present? ? "#{SITE_URL}#{path}" : "#{SITE_URL}#{request.path}"
  end

  def og_image_url(image_path = nil)
    path = image_path.presence || DEFAULT_OG_IMAGE
    path.start_with?("http") ? path : "#{SITE_URL}#{path}"
  end

  def seo_meta_tags(
    title: nil,
    description: nil,
    image: nil,
    type: "website",
    published_at: nil,
    updated_at: nil,
    author: "Jalen"
  )
    desc = meta_description(description)
    page_title(title)
    img_url = og_image_url(image)
    url = canonical_url

    tags = []

    tags << tag.meta(name: "description", content: desc)
    tags << tag.link(rel: "canonical", href: url)

    tags << tag.meta(property: "og:site_name", content: SITE_NAME)
    tags << tag.meta(property: "og:type", content: type)
    tags << tag.meta(property: "og:title", content: title || SITE_NAME)
    tags << tag.meta(property: "og:description", content: desc)
    tags << tag.meta(property: "og:url", content: url)
    tags << tag.meta(property: "og:image", content: img_url)
    tags << tag.meta(property: "og:image:width", content: "1200")
    tags << tag.meta(property: "og:image:height", content: "630")
    tags << tag.meta(property: "og:locale", content: "en_US")

    if published_at.present?
      tags << tag.meta(property: "article:published_time", content: published_at.iso8601)
    end
    if updated_at.present?
      tags << tag.meta(property: "article:modified_time", content: updated_at.iso8601)
    end
    if type == "article"
      tags << tag.meta(property: "article:author", content: author)
    end

    tags << tag.meta(name: "twitter:card", content: "summary_large_image")
    tags << tag.meta(name: "twitter:site", content: TWITTER_HANDLE)
    tags << tag.meta(name: "twitter:creator", content: TWITTER_HANDLE)
    tags << tag.meta(name: "twitter:title", content: title || SITE_NAME)
    tags << tag.meta(name: "twitter:description", content: desc)
    tags << tag.meta(name: "twitter:image", content: img_url)

    safe_join(tags, "\n    ")
  end

  def article_json_ld(post)
    {
      "@context": "https://schema.org",
      "@type": "BlogPosting",
      headline: post.title,
      description: post.description,
      image: og_image_url,
      author: {
        "@type": "Person",
        name: "Jalen",
        url: "#{SITE_URL}/about"
      },
      publisher: {
        "@type": "Person",
        name: "Jalen",
        url: SITE_URL
      },
      datePublished: post.published_at.iso8601,
      dateModified: post.updated_at.iso8601,
      mainEntityOfPage: {
        "@type": "WebPage",
        "@id": canonical_url(post_path(slug: post.slug))
      },
      url: canonical_url(post_path(slug: post.slug)),
      wordCount: post.body.to_s.split.size,
      timeRequired: "PT#{post.reading_time_minutes}M"
    }.to_json
  end

  def website_json_ld
    {
      "@context": "https://schema.org",
      "@type": "WebSite",
      name: SITE_NAME,
      description: SITE_DESCRIPTION,
      url: SITE_URL,
      author: {
        "@type": "Person",
        name: "Jalen",
        url: "#{SITE_URL}/about"
      }
    }.to_json
  end

  def breadcrumb_json_ld(items)
    {
      "@context": "https://schema.org",
      "@type": "BreadcrumbList",
      itemListElement: items.map.with_index(1) do |item, index|
        {
          "@type": "ListItem",
          position: index,
          name: item[:name],
          item: item[:url]
        }
      end
    }.to_json
  end
end
