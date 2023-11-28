class User < ApplicationRecord
  has_secure_password
  # validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }
  validates :email, uniqueness: { case_sensitive: false }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :password, length: { minimum: 6, message: "must be at least 6 characters" }
  validates :password_confirmation, presence: true

  # authenticate with email and password
  def self.authenticate_with_credentials(email, password)
    @user = User.find_by_email(email.strip.downcase)
    # @user = User.find_by("LOWER(email) = ?", email.strip.downcase)
    if @user && @user.authenticate(password)
      @user
    else
      nil
    end
  end
  
end
