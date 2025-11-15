class AddImageNameToMenuItems < ActiveRecord::Migration[7.1]
  def change
    add_column :menu_items, :image_name, :string
  end
end
