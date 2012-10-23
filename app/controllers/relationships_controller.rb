class RelationshipsController < ApplicationController
	before_filter :signed_in?

	def create
		@tv_show = TvShow.find(params[:relationship][:tv_show_id])
		current_user.follow_show!(@tv_show)
		respond_to do |format|
			format.html {redirect_to @tv_show}
			format.js
		end
	end

	def destroy
		@tv_show = Relationship.find(params[:id]).tv_show
		current_user.unfollow_show!(@tv_show)
		respond_to do |format|
			format.html {redirect_to @tv_show}
			format.js
		end
	end

end
