class AddFieldsToTvShow < ActiveRecord::Migration
  def change
    add_column :tv_shows, :overview, :text
    add_column :tv_shows, :imdb_id, :string
    add_column :tv_shows, :runtime, :string
  end
end
