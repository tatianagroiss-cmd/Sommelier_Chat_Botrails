class AddEmbeddingToBeverages < ActiveRecord::Migration[7.1]
  def change
    add_column :beverages, :embedding, :vector, limit: 1536
  end
end
