class MovieTracker < ActiveRecord::Base
  attr_accessible :movie_id, :rating, :watched
  validates :user_id, presence: true
  validates :movie_id, presence: true

  belongs_to :user
  belongs_to :movie

end
