class OrderItem < ApplicationRecord
  belongs_to :user
  belongs_to :menu_item, optional: true
  belongs_to :wine, optional: true
  belongs_to :beverage, optional: true

  before_save :calculate_total

  validates :quantity, numericality: { greater_than: 0 }

  private

  def calculate_total
    price = menu_item&.price || wine&.price || beverage&.price || 0
    self.total = price * quantity
  end
end
