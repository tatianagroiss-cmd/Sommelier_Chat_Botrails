class Beverage < ApplicationRecord
  has_many :order_items

  validates :name, presence: true
  validates :description, length: { maximum: 30 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :volume, presence: true, numericality: { greater_than: 0 }
end
