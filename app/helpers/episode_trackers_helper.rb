module EpisodeTrackersHelper

	def watched_entire_season_text(tv_show,season_num)
		current_user.watched_entire_season?(tv_show,season_num) ? "Mark this Season as Need to Watch" : "Mark this Season as Watched"
	end

	def watched_entire_series_text(tv_show)
		current_user.watched_entire_series?(tv_show) ? "Mark Entire Series as Need to Watch" : "Mark Entire Series as Watched"
	end

end
