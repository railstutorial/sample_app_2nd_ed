class AddToopherToUsers < ActiveRecord::Migration
  def change
    add_column :users, :toopher_pairing_id, :string
  end
end
