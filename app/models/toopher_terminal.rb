class ToopherTerminal < ActiveRecord::Base
  attr_accessible :cookie_value, :terminal_name

  belongs_to :user
end
