# == Schema Information
#
# Table name: episode_trackers
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  episode_id :integer
#  watched    :boolean
#  rating     :boolean
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class EpisodeTracker < ActiveRecord::Base
  attr_accessible :episode_id, :watched
  validates :user_id, presence: true
  validates :episode_id, presence: true
  
  belongs_to :user
  belongs_to :episode

end


