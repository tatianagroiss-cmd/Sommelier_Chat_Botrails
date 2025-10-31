class OrderItem < ApplicationRecord
  belongs_to :user, foreign_key: "id_user"
  belongs_to :menu_item, optional: true
  belongs_to :wine, optional: true
  belongs_to :beverage, optional: true

  before_save :set_total

  validates :quantity, numericality: { greater_than: 0 }

  private

  def set_total
    price = menu_item&.price || wine&.price || beverage&.price || 0
    self.total = price * quantity
  end
end
