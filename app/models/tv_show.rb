class TvShow < ActiveRecord::Base
  attr_accessible :tvdb_id, :name, :year, :network, :genre
  validates :name, presence: true, length: { maximum: 100 }
  
  has_many :episodes, dependent: :destroy
  has_and_belongs_to_many :users
  
end
