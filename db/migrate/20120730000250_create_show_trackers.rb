class CreateShowTrackers < ActiveRecord::Migration
  def change
    create_table :show_trackers do |t|
      t.integer :user_id
      t.integer :episode_id
      t.boolean :watched

      t.timestamps
    end
    add_index :show_trackers, [:user_id, :episode_id]
  end
end