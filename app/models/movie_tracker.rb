class MovieTracker < ActiveRecord::Base
  attr_accessible :movie_id, :rating, :watched
  validates :user_id, presence: true
  validates :movie_id, presence: true

  belongs_to :user
  belongs_to :movie

end
# == Schema Information
#
# Table name: movie_trackers
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  movie_id   :integer
#  watched    :boolean
#  rating     :boolean
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

