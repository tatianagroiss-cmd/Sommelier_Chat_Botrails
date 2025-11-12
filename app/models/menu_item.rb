class MenuItem < ApplicationRecord
  has_many :order_items
  has_neighbors :embedding
  after_create :set_embedding

  validates :name, presence: true
  validates :description, length: { maximum: 300 }
  validates :price, presence: true, numericality: { greater_than: 0 }


  def index
  end

  private

  def set_embedding
    embedding = RubyLLM.embed("Dish: #{name}. #{description}. #{price}")
    update(embedding: embedding.vectors)
  end
end
