class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
      # by default, class_name: "Micropost"
      # by default, foreign_key: "user_id"

  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
      # has_many :(creating method name), class_name: (referred class name)
      #   active_relationships method is created to access instances in Relationship class from User class
      #   foreign_key is to specifiy external key name in referred class
      #     Here, follower_id in Relationship class can be used in User class

  has_many :passive_relationships, class_name:  "Relationship", foreign_key: "followed_id", dependent:   :destroy

  has_many :following, through: :active_relationships, source: :followed
      # has_many :{creating method name}, through: (specified integrated model)
      #   => following class is created.
      #   following method does below
      #     => active_relationship method is carried out to the instance in user class
      #     => instances in Relationship table are obtained.
      #     => followed method is carried out to each item in the instance of Relationship table.     
      #     ==> ex. @user.active_relationships.map(&:followed)
      #     ===> followed method is defined in Relationship class belongs to follower

  has_many :followers, through: :passive_relationships, source: :follower

  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email
  before_create :create_activation_digest
  validates :name,  presence: true, 
                    length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
                    length: { maximum: 255 }, 
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  has_secure_password   
      # validation for user creation
  validates :password, presence: true, length: {minimum: 6}, allow_nil: true

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
        # created pw -> hashed
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    self.update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # def authenticated?(remember_token)
  #   return false if remember_digest.nil?
  #   BCrypt::Password.new(remember_digest).is_password?(remember_token)
  #     # to check if remember_digest is hashed(digested) remember_token
  #     # remember_token is not attr_accessor.
  #         # it's from 'cookies.permanent[:remember_token] = user.remember_token' in sessions_helper
  #         # it's plain text
  #     # remember_digest is hashed(digested) remember_token
  # end

  def forget
    self.update_attribute(:remember_digest, nil)
  end

  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    self.reset_sent_at < 2.hours.ago
        # expired if 2 hours ago or before
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships
        WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
        OR user_id = :user_id", user_id: id)
          # SQL grammer
  end

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end


  
  private

    def downcase_email
      self.email = email.downcase
    end

    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

end
