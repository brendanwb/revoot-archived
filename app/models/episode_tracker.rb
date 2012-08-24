class EpisodeTracker < ActiveRecord::Base
  attr_accessible :episode_id, :watched
  validates :user_id, presence: true
  validates :episode_id, presence: true
  
  belongs_to :user
  belongs_to :episode

end
