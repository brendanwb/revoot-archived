class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.integer :tmdb_id
      t.string :imdb_id
      t.string :title
      t.string :release_date
      t.text :overview
      t.string :status
      t.integer :run_time
      t.string :production_company
      t.string :language
      t.string :genre

      t.timestamps
    end
    add_index :movies, :title
  end
end
