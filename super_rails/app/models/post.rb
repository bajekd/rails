class Post < ApplicationRecord
  belongs_to :user, counter_cache: true
  has_many :comments, as: :commentable

  acts_as_votable

  extend FriendlyId
  friendly_id :title, use: %i[slugged finders history]

  def should_generate_new_friendly_id?
    title_changed?
  end

  validates :title, presence: true
  validates :body, presence: true
  validates :description, presence: true

  MIN_TITLE_LENGTH = 5
  MAX_TITLE_LENGTH = 512
  MAX_DESCRIPTION_LENGTH = 1024
  MAX_BODY_LENGTH = 15_000

  validates :title, length: { in: MIN_TITLE_LENGTH..MAX_TITLE_LENGTH }
  validates :description, length: { maximum: MAX_DESCRIPTION_LENGTH }
  validates :body, length: { maximum: MAX_BODY_LENGTH }

  scope :free, -> { where(premium: false) }
  scope :premium, -> { where(premium: true) }

  scope :my_voted, ->(user) { where(id: user.find_voted_items.map(&:id)) }
  scope :my_upvoted, ->(user) { where(id: user.find_up_voted_items.map(&:id)) }
  scope :my_downvoted, ->(user) { where(id: user.find_down_voted_items.map(&:id)) }
  scope :my_unvoted, ->(user) { where.not(id: user.find_voted_items.map(&:id)) }

  def upvote_percentage
    cached_votes_up.to_d / cached_votes_total.to_d * 100
  end

  def downvote_percentage
    cached_votes_down.to_d / cached_votes_total.to_d * 100
  end
end
