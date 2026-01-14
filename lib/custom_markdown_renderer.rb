class CustomMarkdownRenderer < Redcarpet::Render::HTML
  def initialize(extensions = {})
    super
    @headers = {}
    @rouge_formatter = Rouge::Formatters::HTML.new
  end

  def header(text, header_level)
    id = generate_id(text)
    unique_id = ensure_uniqueness(id)

    "<h#{header_level} id=\"#{unique_id}\">#{text}</h#{header_level}>"
  end

  def block_code(code, language)
    language = language&.strip&.downcase
    language = nil if language&.empty?

    lexer = Rouge::Lexer.find(language) || Rouge::Lexers::PlainText.new
    highlighted = @rouge_formatter.format(lexer.lex(code))

    lang_label = language || "text"
    %(<div class="code-block" data-controller="code-copy" data-language="#{lang_label}">
<div class="code-header">
<span class="code-language">#{lang_label}</span>
<button type="button" class="code-copy-btn" data-action="click->code-copy#copy" data-code-copy-target="button">Copy</button>
</div>
<pre class="highlight"><code data-code-copy-target="code">#{highlighted}</code></pre>
</div>)
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
