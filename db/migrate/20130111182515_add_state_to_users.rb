class AddStateToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :confirmation_token, :string
  	add_column :users, :confirmation_token_sent, :datetime
    add_column :users, :active, :boolean, default: false
  end
end
