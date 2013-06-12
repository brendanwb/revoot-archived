class StaticPagesController < ApplicationController
  def home
    unless params[:search].nil?
      @tv_search    = TvShow.search(params[:search])
      @tv_shows     = @tv_search
      @movie_search = Movie.search(params[:search])
      @movies       = @movie_search
    end
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
  
end
