class MakeOrderItemAssociationsOptional < ActiveRecord::Migration[7.1]
  def change
    change_column_null :order_items, :menu_item_id, true
    change_column_null :order_items, :wine_id, true
    change_column_null :order_items, :beverage_id, true
  end
end
