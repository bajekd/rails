class Agent < ApplicationRecord
  belongs_to :agency

  scope :find_by_phone_or_email, lambda { |phone:, email:|
    where('phone = :phone OR email = :email', phone:, email:)
  }

  validates :agency, presence: true
  validates :phone, uniqueness: { allow_nil: true, allow_blank: true }
  validates :email, uniqueness: { allow_nil: true, allow_blank: true }
end
