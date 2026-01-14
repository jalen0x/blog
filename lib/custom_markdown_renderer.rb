class CustomMarkdownRenderer < Redcarpet::Render::HTML
  def initialize(extensions = {})
    super
    @headers = {}
  end

  def header(text, header_level)
    id = generate_id(text)
    unique_id = ensure_uniqueness(id)

    "<h#{header_level} id=\"#{unique_id}\">#{text}</h#{header_level}>"
  end

  private

  def generate_id(text)
    parameterized = text.parameterize

    if parameterized.blank?
      text.strip.gsub(/\s+/, "-")
    else
      parameterized
    end
  end

  def ensure_uniqueness(id)
    count = @headers[id] || 0

    @headers[id] = count + 1

    return id if count == 0

    "#{id}-#{count}"
  end
end
