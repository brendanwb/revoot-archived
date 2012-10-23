class TvShowsController < ApplicationController
  def index
  	@tv_shows = TvShow.paginate(page: params[:page])
  end

  def show
  	@tv_show = TvShow.find(params[:id])
  	@seasons = @tv_show.episodes
  end

  def tv_show_followers
  	redirect_to user_path
  end
end
