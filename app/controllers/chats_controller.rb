class ChatsController < ApplicationController
  def create
    @chat = Chat.create(user: current_user, mood_id: params[:mood_id])
    redirect_to chat_path(@chat)
  end

  def show
     @chat = Chat.find(params[:id])
  end
end
