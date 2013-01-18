# == Schema Information
#
# Table name: users
#
#  id                      :integer         not null, primary key
#  name                    :string(255)
#  email                   :string(255)
#  created_at              :datetime        not null
#  updated_at              :datetime        not null
#  password_digest         :string(255)
#  remember_token          :string(255)
#  admin                   :boolean         default(FALSE)
#  password_reset_token    :string(255)
#  password_reset_sent_at  :datetime
#  confirmation_token      :string(255)
#  confirmation_token_sent :datetime
#  state                   :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  has_secure_password
  has_many :episode_trackers, dependent: :destroy
  has_many :episodes, through: :episode_trackers
  has_many :tv_relationships, dependent: :destroy
  has_many :followed_shows, through: :tv_relationships, source: :tv_show
  has_many :movies, through: :movie_trackers
  has_many :movie_trackers, dependent: :destroy

  before_save { |user| user.email = email.downcase }
  before_save { create_remember_token(:remember_token) }
  
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, 
                    uniqueness: { case_sensitive: false }         
  validates :password, length: { minimum: 6 }, unless: Proc.new { |user| user.password.nil? }
  validates :password_confirmation, presence: true, unless: Proc.new { |user| user.password.nil? }

  # state_machine do
  #   state :pending
  #   state :active

  #   event :activate do
  #     transition :pending => :active, :on_transition => :activate_user
  #   end
  # end

  def send_password_reset
    create_remember_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def send_confirmation_email
    create_remember_token(:confirmation_token)
    self.confirmation_token_sent = Time.zone.now
    save!
    UserMailer.confirmation_email(self).deliver
  end

  def activate_user
    self.state = "active"
    save!
  end

  def following_show?(tv_show)
    tv_relationships.find_by_tv_show_id(tv_show.id)
  end
  
  def follow_show!(tv_show)
    tv_relationships.create!(tv_show_id: tv_show.id)
    episodes = tv_show.episodes
    episodes.each do |episode|
      episode_trackers.create!(episode_id: episode.id, watched: 0)
    end
  end

  def unfollow_show!(tv_show)
    tv_relationships.find_by_tv_show_id(tv_show.id).destroy
    episodes = Episode.where(tv_show_id: tv_show.id)
    episodes.each do |episode|
      episode_trackers.find_by_episode_id(episode.id).destroy
    end
  end

  def percent_watched?(tv_show)
    if following_show?(tv_show)
      @episode_count = tv_show.episodes.count
      episodes = tv_show.episodes
      watched_count = []
      episodes.each do |episode|
        if watched_episode?(episode)
          watched_count << episode
        end
      end
      a = watched_count.count + 0.00
      b = @episode_count + 0.00
      percent = (a / b) * 100
    else
      percent = 0
    end
  end

  def watched_episode?(episode)
    @tracker = episode_trackers.find_by_episode_id(episode.id)
    @tracker.watched
  end

  def watch_episode!(episode)
    @tracker = episode_trackers.find_by_episode_id(episode.id)
    @tracker.watched = true
    @tracker.save
  end

  def unwatch_episode!(episode)
    @tracker = episode_trackers.find_by_episode_id(episode.id)
    @tracker.watched = false
    @tracker.save
  end

  def watched_entire_series?(tv_show)
    episodes = tv_show.episodes
    watch_history = []
    episodes.each do |episode|
      watch_history << watched_episode?(episode)
    end
    unless watch_history.include?(false)
      true
    else
      false
    end
  end

  def watched_all_episodes!(tv_show)
    episodes = tv_show.episodes
    episodes.each do |episode|
      watch_episode!(episode)
    end
  end

  def watched_entire_season?(tv_show,season_num)
    episodes = tv_show.episodes.where(season_num:season_num)
    watch_history = []
    episodes.each do |episode|
      watch_history << watched_episode?(episode)
    end
    unless watch_history.include?(false)
      true
    else
      false
    end
  end

  def watched_entire_season!(tv_show,season_num)
    episodes = tv_show.episodes.where(season_num:season_num)
    episodes.each do |episode|
      watch_episode!(episode)
    end
  end

  def unwatch_entire_season!(tv_show,season_num)
    episodes = tv_show.episodes.where(season_num:season_num)
    episodes.each do |episode|
      unwatch_episode!(episode)
    end
  end

  def following_movie?(movie)
    movie_trackers.find_by_movie_id(movie.id)
  end

  def follow_movie!(movie)
    movie_trackers.create!(movie_id: movie.id)
  end

  def unfollow_movie!(movie)
    movie_trackers.find_by_movie_id(movie.id).destroy
  end
  
  def watched_movie?(movie)
    @movie_tracker = movie_trackers.find_by_movie_id(movie.id)
    @movie_tracker.watched
  end

  private
    # modified for use with more than one column
    def create_remember_token(column)
      self[column] = SecureRandom.urlsafe_base64
    end

end
