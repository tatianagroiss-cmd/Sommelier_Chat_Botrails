class AddQuantityAndTotalToOrderItems < ActiveRecord::Migration[7.1]
  def change
    add_column :order_items, :quantity, :integer
    add_column :order_items, :total, :decimal
  end
end
