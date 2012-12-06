class EpisodeTrackersController < ApplicationController
  before_filter :signed_in?
  
  def update
  	@episode = Episode.find(params[:episode_tracker][:episode_id])
  	if !current_user.watched_episode?(@episode)
	  	current_user.watch_episode!(@episode)
		else
			current_user.unwatch_episode!(@episode)
		end
		respond_to do |format|
			format.html {redirect_to @tv_show}
			# this works with the ajax by feeding the newly rendered partial in update.js.erb
			# $curr_episode as the @episode variable that was just updated
			format.js {$curr_episode = @episode}
		end
  end

  def toggle_watched_season
  	@tv_show    = TvShow.find(params[:id])
  	@season_num = params[:season]
  	if !current_user.watched_entire_season?(@tv_show,@season_num)
  		current_user.watched_entire_season!(@tv_show,@season_num)
  	else
  		current_user.unwatch_entire_season!(@tv_show,@season_num)
  	end
  	redirect_to @tv_show
    # render :nothing => true
  end

  def toggle_entire_show
    @tv_show    = TvShow.find(params[:id])
    if !current_user.watched_entire_series?(@tv_show)
      current_user.watched_all_episodes!(@tv_show)
    end
    redirect_to @tv_show
    # render :nothing => true
  end

end
