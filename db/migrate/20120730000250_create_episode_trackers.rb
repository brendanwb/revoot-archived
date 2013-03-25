class CreateEpisodeTrackers < ActiveRecord::Migration
  def change
    create_table :episode_trackers do |t|
      t.integer :user_id
      t.integer :episode_id
      t.boolean :watched
      t.boolean :rating

      t.timestamps
    end
    add_index :episode_trackers, [:user_id, :episode_id]
  end
end