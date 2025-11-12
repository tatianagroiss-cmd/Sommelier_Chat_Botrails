class Mood < ApplicationRecord
  has_many :chats, dependent: :nullify
end
