class ChangeShowTrackertoEpisodeTracker < ActiveRecord::Migration
  def change
    rename_table :show_trackers, :episode_trackers
  end
end
