class Post < ApplicationRecord
  validates :title, presence: true, length: { maximum: 200 }
  validates :slug, presence: true, uniqueness: true

  before_validation :ensure_slug

  def formatted_date
    published_at.strftime("%Y-%m-%d")
  end

  def description
    excerpt.presence || auto_excerpt
  end

  def reading_time_minutes
    words_per_minute = 200
    word_count = body.to_s.split.size
    [ (word_count / words_per_minute.to_f).ceil, 1 ].max
  end

  private

  def ensure_slug
    self.slug = title.to_s.parameterize if slug.blank? && title.present?
  end

  def auto_excerpt
    plain_text = body.to_s
      .gsub(/```[\s\S]*?```/, "")
      .gsub(/`[^`]+`/, "")
      .gsub(/\[([^\]]+)\]\([^)]+\)/, '\1')
      .gsub(/[#*_~>]/, "")
      .gsub(/\n+/, " ")
      .strip

    plain_text.truncate(160, separator: " ")
  end
end
