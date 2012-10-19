# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean         default(FALSE)
#

class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  has_secure_password
  has_many :episode_trackers, dependent: :destroy
  has_many :episodes, through: :episode_trackers
  has_many :relationships, dependent: :destroy
  has_many :followed_shows, through: :relationships, source: :tv_show

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token
  
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, 
                    uniqueness: { case_sensitive: false }         
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  def following_show?(tv_show)
    relationships.find_by_tv_show_id(tv_show.id)
  end
  
  def follow_show!(tv_show)
    relationships.create!(tv_show_id: tv_show.id)
  end

  def unfollow_show!(tv_show)
    relationships.find_by_tv_show_id(tv_show.id).destroy
  end

  private
  
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
