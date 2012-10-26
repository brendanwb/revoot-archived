class CreateTvRelationships < ActiveRecord::Migration
  def change
    create_table :tv_relationships do |t|
      t.integer :user_id
      t.integer :tv_show_id

      t.timestamps
    end

    add_index :tv_relationships, :user_id
    add_index :tv_relationships, :tv_show_id
    add_index :tv_relationships, [:user_id, :tv_show_id], unique: true
  end
end
