class CreateTvShows < ActiveRecord::Migration
  def change
    create_table :tv_shows do |t|
      t.string :tvdb_id
      t.string :name
      t.string :year
      t.string :network
      t.string :genre

      t.timestamps
    end
    add_index :tv_shows, :tvdb_id, unique: true
  end
end
