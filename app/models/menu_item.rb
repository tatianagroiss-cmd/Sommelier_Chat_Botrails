class MenuItem < ApplicationRecord
  has_many :order_items

  validates :name, presence: true
  validates :description, length: { maximum: 50 }
  validates :price, presence: true, numericality: { greater_than: 0 }
end
