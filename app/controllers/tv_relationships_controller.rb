class TvRelationshipsController < ApplicationController
	before_filter :signed_in_user

	def create
		@tv_show = TvShow.find(params[:tv_relationship][:tv_show_id])
		current_user.follow_show!(@tv_show)
		respond_to do |format|
			format.html {redirect_to @tv_show}
			format.js {$curr_show = @tv_show}
		end
	end

	def destroy
		@tv_show = TvRelationship.find(params[:id]).tv_show
		current_user.unfollow_show!(@tv_show)
		respond_to do |format|
			format.html {redirect_to @tv_show}
			format.js {$curr_show = @tv_show}
		end
	end

end
