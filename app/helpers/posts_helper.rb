require "custom_markdown_renderer"

module PostsHelper
  def markdown(text)
    renderer = CustomMarkdownRenderer.new(
      hard_wrap: true,
      filter_html: false,
      with_toc_data: true,
      prettify: true
    )
    markdown = Redcarpet::Markdown.new(
      renderer,
      autolink: true,
      tables: true,
      fenced_code_blocks: true,
      strikethrough: true,
      superscript: true,
      highlight: true,
      footnotes: true,
      no_intra_emphasis: true,
      space_after_headers: true
    )
    markdown.render(text).html_safe
  end
end
