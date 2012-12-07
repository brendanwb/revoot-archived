# == Schema Information
#
# Table name: episodes
#
#  id          :integer         not null, primary key
#  tv_show_id  :integer
#  tvdb_id     :string(255)
#  name        :string(255)
#  season_num  :string(255)
#  episode_num :string(255)
#  first_aired :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Episode < ActiveRecord::Base
  attr_accessible :tvdb_id, :imdb_id, :name, :season_num, :episode_num, :first_aired, :overview
  validates :tv_show_id, presence: true
  validates :name, presence: true, length: { maximum: 100 }
  validates :season_num, presence: true, length: { maximum: 4 }
  validates :episode_num, presence: true, length: { maximum: 5 }
  
  belongs_to :tv_show
  has_many :episode_trackers, dependent: :destroy
  has_many :users, :through => :episode_trackers

end


