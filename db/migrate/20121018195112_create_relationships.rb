class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :user_id
      t.integer :tv_show_id

      t.timestamps
    end

    add_index :relationships, :user_id
    add_index :relationships, :tv_show_id
    add_index :relationships, [:user_id, :tv_show_id], unique: true
  end
end
