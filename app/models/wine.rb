class Wine < ApplicationRecord
  has_many :order_items

  validates :name, presence: true
  validates :description, length: { maximum: 150 }
  validates :country, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :volume, presence: true

end
