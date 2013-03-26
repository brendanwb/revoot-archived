class MoviesController < ApplicationController
  def index
  	@movies = Movie.all.sort_by { |obj| obj.title }
  end

  def show
  	@movie        = Movie.find(params[:id])
  	@title        = @movie.title
  	@release_date = @movie.release_date
  	@status       = @movie.status
  	@overview     = @movie.overview
  end
end
