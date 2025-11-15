class MessagesController < ApplicationController
  def index
  end

  def create
    @chat = Chat.find(params[:chat_id])
    content = params[:message][:content]

    embedding = RubyLLM.embed(content).vectors

    similar_items = []

    similar_items += MenuItem.nearest_neighbors(:embedding, embedding, distance: "euclidean").first(3)
    similar_items += Wine.nearest_neighbors(:embedding, embedding, distance: "euclidean").first(3)
    similar_items += Beverage.nearest_neighbors(:embedding, embedding, distance: "euclidean").first(3)

    similar_items = similar_items.uniq.first(3)

    instructions = system_prompt
    instructions += similar_items.map { |item| item_prompt(item) }.join("\n\n")

    if @chat.with_instructions(instructions).ask(content)
    redirect_to chat_path(@chat)
    else
      @message = @chat.messages.last
      render "chats/show", status: :unprocessable_entity
    end
  end

  private

  def item_prompt(item)
    <<~TEXT
      ITEM:
      Name: #{item.name}
      Price: #{item.price}
      Description: #{item.try(:description)}
    TEXT
  end

  def system_prompt
  "You are a sommelier assistant. Recommend food and wines based on menu and drinks."
  end


end
