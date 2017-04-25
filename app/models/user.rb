class User < ApplicationRecord
  has_secure_password

  has_many :interests_users
  has_many :interests, through: :interests_users

  belongs_to :location, required: false # TODO will have to make sure location is given in edit profile page

  # has_many :friendships
  # has_many :friends, through: :friendships
  # has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id"
  # has_many :inverse_friends, through: :inverse_friendships, source: :user

  has_many :messages
  has_many :chatrooms, through: :messages

  # validates :first_name, :last_name, :email, presence: true
  # validates_uniqueness_of :email, case_sensitive: false
  # validates :password, :password_confirmation, presence: true
  # validates :password, length: { in: 4..15 }

  def self.authenticate_with_credentials(email, password)
    user = User.find_by_email(email.strip)

    if user && user.authenticate(password)
      return user
    else
      return nil
    end
  end
end
