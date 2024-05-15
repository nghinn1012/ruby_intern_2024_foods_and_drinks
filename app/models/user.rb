class User < ApplicationRecord
  attr_accessor :remember_token

  ATTRIBUTES = %i(name email password password_confirmation
  date_of_birth gender).freeze
  has_many :orders, dependent: :destroy
  has_many :notifications, dependent: :destroy
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
  has_secure_password

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create(string, cost:)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
    remember_digest
  end

  def session_token
    remember_digest || remember
  end

  def authenticated? remember_token
    return false unless remember_digest

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_column :remember_digest, nil
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def downcase_email
    email.downcase!
  end
end
