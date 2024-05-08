class User < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_many :notifications, dependent: :destroy
  enum role: {admin: 0, user: 1}
  validates :first_name, presence: true,
    length: {maximum: Settings.validates.users.name.max_length}
  validates :last_name, presence: true,
    length: {maximum: Settings.validates.users.name.max_length}
  validates :email, presence: true, uniqueness: true,
    format: {with: Settings.validates.users.email.format},
    length: {maximum: Settings.validates.users.email.max_length}
  validates :password, presence: true,
    length: {minimum: Settings.validates.users.password.min_length}
  has_secure_password

  private

  def downcase_email
    email.downcase!
  end
end
