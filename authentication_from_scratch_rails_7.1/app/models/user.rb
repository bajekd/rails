class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  normalizes :email, with: ->(email) { email.strip.downcase }

  generates_token_for :password_reset, expires_in: 15.minutes do
    password_salt&.last(15)
  end
end
