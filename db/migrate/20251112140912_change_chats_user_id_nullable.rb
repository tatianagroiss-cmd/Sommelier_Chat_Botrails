class ChangeChatsUserIdNullable < ActiveRecord::Migration[7.1]
  def change
    change_column_null :chats, :user_id, true
    remove_foreign_key :chats, :users, column: :user_id, if_exists: true
  end
end
