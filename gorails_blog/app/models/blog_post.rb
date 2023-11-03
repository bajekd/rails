class BlogPost < ApplicationRecord
  has_one_attached :cover_image
  has_rich_text :content

  validates :title, presence: true
  validates :content, presence: true

  scope :sorted, lambda {
                   order(arel_table[:published_at].desc.nulls_first).order(updated_at: :desc)
                 }  # Arel.sql("published_at DESC NULLS FIRST")
  scope :draft, -> { where(published_at: nil) }
  scope :published, -> { where('published_at <= :current_time', current_time: Time.now) }
  scope :scheduled, -> { where('published_at > :current_time', current_time: Time.current) }

  def draft?
    published_at.nil?
  end

  def published?
    published_at? && published_at <= Time.current
  end

  def scheduled?
    published_at? && published_at > Time.current
  end
end
