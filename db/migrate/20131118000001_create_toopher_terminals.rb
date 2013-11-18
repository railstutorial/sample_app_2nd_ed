class CreateToopherTerminals < ActiveRecord::Migration
  def change
    create_table :toopher_terminals do |t|
    	t.integer :user_id
      t.string :terminal_name
      t.string :cookie_value

      t.timestamps
    end
  end
end
