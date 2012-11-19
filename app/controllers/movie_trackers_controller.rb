class MovieTrackersController < ApplicationController
  before_filter :signed_in?

  def create
  	@movie = Movie.find(params[:movie_tracker][:movie_id])
  	current_user.follow_movie!(@movie)
  	respond_to do |format|
  		format.html {redirect_to @movie}
  		format.js {$curr_movie = @movie}
  	end
  end

  def destroy
  	@movie = MovieTracker.find(params[:id]).movie
  	current_user.unfollow_movie!(@movie)
  	respond_to do |format|
  		format.html {redirect_to @movie}
  		format.js {$curr_movie = @movie}
  	end
  end

end
