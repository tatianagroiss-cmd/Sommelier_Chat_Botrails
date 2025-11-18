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
