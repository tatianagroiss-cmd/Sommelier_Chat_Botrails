class CreateBeverages < ActiveRecord::Migration[7.1]
  def change
    create_table :beverages do |t|
      t.string :category
      t.string :name
      t.text :description
      t.decimal :price
      t.string :volume

      t.timestamps
    end
  end
end
