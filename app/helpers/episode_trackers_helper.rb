module EpisodeTrackersHelper

	def watched_entire_season_text(tv_show,season_num)
		current_user.watched_entire_season?(tv_show,season_num) ? "Watched Entire Season" : "Need to Watch Season"
	end

end
