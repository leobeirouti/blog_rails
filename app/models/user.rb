class User < ApplicationRecord
  has_many :articles
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
       :recoverable, :rememberable, :validatable,
       :two_factor_authenticatable,
       otp_secret_encryption_key: Rails.application.credentials[:otp_secret_key]
  # database_authenticatable,:registerable,
  # recoverable, :rememberable, :validatable

  before_create :generate_otp_secret

  def generate_otp_secret
    self.otp_secret ||= User.generate_otp_secret
  end
end
