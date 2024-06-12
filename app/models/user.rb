class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  attr_accessor :remember_token

  ATTRIBUTES = %i(first_name last_name email address phone password
  password_confirmation image).freeze
  has_many :orders, dependent: :destroy
  has_many :notifications, foreign_key: "receiver_id", dependent: :destroy
  has_one_attached :image, dependent: :purge_later
  enum role: {admin: 0, user: 1}, _suffix: true
  validates :first_name, presence: true,
    length: {maximum: Settings.validates.users.name.max_length}
  validates :last_name, presence: true,
    length: {maximum: Settings.validates.users.name.max_length}
  validates :email, presence: true, uniqueness: true,
    format: {with: Settings.validates.users.email.format},
    length: {maximum: Settings.validates.users.email.max_length}
  validates :password, presence: true,
    length: {minimum: Settings.validates.users.password.min_length}

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def downcase_email
    email.downcase!
  end
end
