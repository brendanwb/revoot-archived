# == Schema Information
#
# Table name: movies
#
#  id                 :integer         not null, primary key
#  tmdb_id            :integer
#  imdb_id            :string(255)
#  title              :string(255)
#  release_date       :string(255)
#  overview           :text
#  status             :string(255)
#  run_time           :integer
#  production_company :string(255)
#  language           :string(255)
#  genre              :string(255)
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#

class Movie < ActiveRecord::Base
  attr_accessible :genre, :imdb_id, :language, :overview, :production_company, :release_date, :run_time, :status, :title, :tmdb_id
  validates :title, presence: true, length: { maximum: 100 }
  validates :tmdb_id, presence: true
  validates :run_time, length: { maximum: 3 }

  has_many :users, through: :movie_trackers
  has_many :movie_trackers, dependent: :destroy

  def search(query)
  	if query
      self.search query
  	else
      return "No results!"
    end
  end
  
end


