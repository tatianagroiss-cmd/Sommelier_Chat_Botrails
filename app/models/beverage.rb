class Beverage < ApplicationRecord
  has_many :order_items
  #has_neighbors :embedding
  #after_create :set_embedding

  validates :name, presence: true
  validates :description, length: { maximum: 300 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :volume, presence: true, numericality: { greater_than: 0 }

  private

  #def set_embedding
    #embedding = RubyLLM.embed("Beverage: #{name}. Description: #{description}. Price: #{price}")
    #update(embedding: embedding.vectors)
  #end
end
