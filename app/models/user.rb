class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation

  # Downcases all users email's in the database
  before_save { email.downcase! }

  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  
  # Creates and authenticates a secure password w. password_digest.
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  has_secure_password





end
