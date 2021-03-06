class User < ActiveRecord::Base
  attr_accessible :name, :year, :email, :password, :password_confirmation,
                  :profile_info
  has_secure_password

  has_many :microposts, dependent: :destroy 
    # says user has many microposts. And when user is destroyed,
    #  so should the user's microposts.
  has_many :relationships, foreign_key: "follower_id", 
                            dependent: :destroy

  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                    class_name: "Relationship", 
                                    dependent: :destroy
                                    
  has_many :followers, through: :reverse_relationships, 
                        source: :follower 

  # Downcases all users email's in the database
  before_save { |user| user.email = user.email.downcase }
  before_save :create_remember_token

  validates :profile_info, presence: true, length: { maximum: 2000 }
  
  validates :name, presence: true, length: { maximum: 50 }


  validates :year, presence: true, inclusion: { in: 1920..2030 },
                              exclusion: { in: "a".."z" }, 
                              length: { minimum: 4, maximum: 4 } 


  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  
  # Creates and authenticates a secure password w. password_digest.
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true


  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy

  end

  def feed 
    Micropost.from_users_followed_by(self)
  end
  

  private 
    def create_remember_token 
      self.remember_token = SecureRandom.urlsafe_base64
    end

end
