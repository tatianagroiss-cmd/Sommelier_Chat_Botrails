class AddImageToWines < ActiveRecord::Migration[7.1]
  def change
    add_column :wines, :image, :string
  end
end
