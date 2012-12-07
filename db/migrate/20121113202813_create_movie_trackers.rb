class CreateMovieTrackers < ActiveRecord::Migration
  def change
    create_table :movie_trackers do |t|
      t.integer :user_id
      t.integer :movie_id
      t.boolean :watched
      t.boolean :rating

      t.timestamps
    end
    add_index :movie_trackers, [:user_id, :movie_id]
  end
end
