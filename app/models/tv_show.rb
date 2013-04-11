# == Schema Information
#
# Table name: tv_shows
#
#  id         :integer         not null, primary key
#  tvdb_id    :string(255)
#  name       :string(255)
#  year       :string(255)
#  network    :string(255)
#  genre      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class TvShow < ActiveRecord::Base
  attr_accessible :tvdb_id, :name, :year, :network, :genre, :overview
  validates :name, presence: true, length: { maximum: 100 }
  
  has_many :episodes, dependent: :destroy
  has_many :tv_relationships, dependent: :destroy
  has_many :tv_show_followers, through: :tv_relationships, source: :user
  
end


