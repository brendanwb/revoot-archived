class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.integer :tv_show_id
      t.string :tvdb_id
      t.string :imdb_id
      t.string :name
      t.string :season_num
      t.string :episode_num
      t.string :first_aired
      t.text :overview

      t.timestamps
    end
    add_index :episodes, :tv_show_id
  end
end
