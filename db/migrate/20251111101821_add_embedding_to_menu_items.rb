class AddEmbeddingToMenuItems < ActiveRecord::Migration[7.1]
  def change
    add_column :menu_items, :embedding, :vector, limit: 1536
  end
end
