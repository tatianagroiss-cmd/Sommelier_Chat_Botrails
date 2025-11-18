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

    assistant_messages = @chat.messages.where(role: "assistant")
    return redirect_to chat_path(@chat), alert: "No assistant replies found." if assistant_messages.empty?

    confirmed_lines = assistant_messages.flat_map do |msg|
    msg.content.lines.select { |l| l.strip.start_with?("Confirmed:") }

    confirmed_lines.each do |line|
      item_text = line.sub("Confirmed:", "").strip
      delimiter = item_text.include?("—") ? "—" : "-"
      next unless item_text.include?(delimiter)
      name = item_text.split(delimiter).first.strip

      item = MenuItem.find_by("LOWER(name) = ?", name.downcase) ||
            Wine.find_by("LOWER(name) = ?", name.downcase)      ||
            Beverage.find_by("LOWER(name) = ?", name.downcase)

      next unless item

      OrderItem.create!(
        user: User.last,
        menu_item_id: item.is_a?(MenuItem) ? item.id : nil,
        wine_id:      item.is_a?(Wine)      ? item.id : nil,
        beverage_id:  item.is_a?(Beverage)  ? item.id : nil,
        quantity: 1
        )
    end
    redirect_to order_items_path, notice: "Confirmed items added to order!"
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
