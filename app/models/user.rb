class User < ActiveRecord::Base
  validates :user_name, :password_digest, :session_token, presence: true

  before_validation :after_initialize

  has_many :cats,
    class_name: "Cat",
    foreign_key: :user_id,
    primary_key: :id
    
  has_many :cat_rental_requests,
    class_name: "CatRentalRequest",
    foreign_key: :user_id,
    primary_key: :id

  attr_reader :password

  def ensure_session_token
    self.session_token ||= SecureRandom::urlsafe_base64
  end

  def after_initialize
    ensure_session_token
  end

  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64
    self.save!
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    password_digest == password  #this is an alias for is_password, which compares
                          # a digest with a password
  end

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    return user if BCrypt::Password.new(user.password_digest).is_password?(password)
  end

end
