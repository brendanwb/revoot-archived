class AddTvShowUsersJoinTable < ActiveRecord::Migration
  def change
    create_table :tv_shows_users, :id => false do |t|
      t.integer :user_id
      t.integer :tv_show_id
    end
    add_index :tv_shows_users, :user_id
    add_index :tv_shows_users, :tv_show_id
    add_index :tv_shows_users, [:user_id, :tv_show_id]
  end
end
