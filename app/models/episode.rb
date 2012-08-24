class Episode < ActiveRecord::Base
  attr_accessible :tvdb_id, :name, :season_num, :episode_num, :first_aired
  validates :tv_show_id, presence: true
  validates :name, presence: true, length: { maximum: 100 }
  validates :season_num, presence: true, length: { maximum: 4 }
  validates :episode_num, presence: true, length: { maximum: 5 }
  
  belongs_to :tv_show
  has_many :episode_trackers, dependent: :destroy
  has_many :users, :through => :episode_trackers

end
