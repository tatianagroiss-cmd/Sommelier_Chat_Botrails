class Wine < ApplicationRecord
  has_many :order_items
  has_neighbors :embedding
  after_create :set_embedding

  validates :name, presence: true
  validates :description, length: { maximum: 150 }
  validates :country, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :volume, presence: true

  private

  def set_embedding
    embedding = RubyLLM.embed("Wine: #{name}. Description: #{description}. Price: #{price}. Category: #{category}. Country: #{country}")
    update(embedding: embedding.vectors)
  end

end
