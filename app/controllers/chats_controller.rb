class ChatsController < ApplicationController
  def create
    @chat = Chat.create!(
      user: User.last,
      mood_id: params[:mood_id]
    )

      client = RubyLLM.chat(model: "gpt-4o-mini")
      starter_prompt = build_starter_prompt(@chat.mood)

      answer = client.ask(starter_prompt)

      @chat.messages.create!(
        role: "assistant",
        content: answer.content
      )
        redirect_to chat_path(@chat)
  end

  def show
     @chat = Chat.find(params[:id])
  end

  def add_recommendations
    @chat = Chat.find(params[:id])
    last_reply = @chat.messages.where(role: "assistant").last&.content

    return redirect_to chat_path(@chat), alert: "No assistant reply found." if last_reply.blank?

    confirmed_line = last_reply.lines.find { |l| l.strip.start_with?("Confirmed:") }

    return redirect_to chat_path(@chat), alert: "No confirmed items." unless confirmed_line

    item_text = confirmed_line.sub("Confirmed:", "").strip

    unless item_text.include?("—")
      return redirect_to chat_path(@chat), alert: "Invalid confirmation format."
    end

    name = item_text.split("—").first.strip

    item = MenuItem.find_by("LOWER(name) = ?", name.downcase) ||
          Wine.find_by("LOWER(name) = ?", name.downcase)      ||
          Beverage.find_by("LOWER(name) = ?", name.downcase)
    return redirect_to chat_path(@chat), alert: "Item not found." unless item


     OrderItem.create!(
      user: User.last,
      menu_item_id: item.is_a?(MenuItem) ? item.id : nil,
      wine_id:      item.is_a?(Wine)      ? item.id : nil,
      beverage_id:  item.is_a?(Beverage)  ? item.id : nil,
      quantity: 1
      )

    redirect_to chat_path(@chat), notice: "Confirmed items added to order!"
  end



  private
  def build_starter_prompt(mood)

    <<~PROMPT

      You are a sommelier with the personality:

      "#{mood.name} — #{mood.description}"

      Generate ONLY the first message of the conversation.

      STRICT RULES:
      - Greeting must be 10–15 words.
      - Greeting tone MUST reflect the sommelier's personality and mood.
      - After greeting, ask ONE clear question about the guest's food preferences.
      - No recommendations.
      - No dishes.
      - No lists.
      - No wine suggestions.
      - No context beyond greeting + preference question.
      - Absolutely no markdown or formatting.

      OUTPUT FORMAT (strict):
      <Greeting sentence>
      <One question about food preferences>

    PROMPT
  end
end
