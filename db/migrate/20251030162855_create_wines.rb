class CreateWines < ActiveRecord::Migration[7.1]
  def change
    create_table :wines do |t|
      t.string :category
      t.string :name
      t.string :country
      t.text :description
      t.decimal :price
      t.string :volume

      t.timestamps
    end
  end
end
