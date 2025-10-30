class CreateOrderItems < ActiveRecord::Migration[7.1]
  def change
    create_table :order_items do |t|
      t.references :user, null: false, foreign_key: true
      t.references :menu_item, null: false, foreign_key: true
      t.references :wine, null: false, foreign_key: true
      t.references :beverage, null: false, foreign_key: true

      t.timestamps
    end
  end
end
