class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable,
         :trackable, :confirmable,
         :omniauthable, omniauth_providers: %i[google_oauth2 github]

  has_many :invitees, class_name: 'User', foreign_key: :invited_by_id
  has_many :posts, dependent: :restrict_with_error

  acts_as_voter

  extend FriendlyId
  friendly_id :slug, use: :slugged

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: access_token.info.email).first

    user ||= User.create(email: access_token.info.email, password: Devise.friendly_token(length = 32))

    user.provider = access_token.provider
    user.uid = access_token.uid
    user.name = access_token.info.name || user.slug_setter
    user.image = access_token.info.image
    user.skip_confirmation!
    user.save

    user
  end

  def slug_setter
    if name?
      update(slug: name)
    else
      update(slug: email.split(/@/).first)
    end
    self.slug
  end

  def active?
    subscription_status == 'active'
  end
end
