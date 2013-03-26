class TvShowsController < ApplicationController
  def index
  	@tv_shows  = TvShow.all.sort_by { |obj| obj.name }
  end

  def show
  	@tv_show = TvShow.find(params[:id])
    @name    = @tv_show.name
    @year    = @tv_show.year
    @network = @tv_show.network
    genres   = @tv_show.genre.split("|")
    genres.shift
    @genres  = genres.join(", ")
  	@seasons = @tv_show.episodes
  end

  def tv_show_followers
  	redirect_to user_path
  end
end
