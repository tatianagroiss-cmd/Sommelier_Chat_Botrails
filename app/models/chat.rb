class Chat < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :mood, optional: true
  has_many :messages, dependent: :destroy
end
