class OrderItem < ApplicationRecord
  belongs_to :user
  belongs_to :menu_item
  belongs_to :wine
  belongs_to :beverage
end
