class MessagesController < ApplicationController
  def index
  end

  def create
    @chat = Chat.find(params[:chat_id])
    content = params[:message][:content]

     # 1. User embedding
    embedding = RubyLLM.embed(content).vectors

    # 2. Find similar items
    similar_items = []

    similar_items += MenuItem.nearest_neighbors(:embedding, embedding, distance: "euclidean").first(3)
    similar_items += Wine.nearest_neighbors(:embedding, embedding, distance: "euclidean").first(3)
    similar_items += Beverage.nearest_neighbors(:embedding, embedding, distance: "euclidean").first(3)
    similar_items = similar_items.uniq.first(3)

    # 3. Build items text
    items_text = similar_items.map { |item| item_prompt(item) }.join("\n\n")

    # 4. Build full prompt for RubyLLM
    full_prompt = [
      system_prompt,
      "MENU CONTEXT:",
      items_text.presence || "No relevant items found.",
      "USER MESSAGE:",
      content
    ].join("\n\n")

     # 5. Ask LLM
     client = RubyLLM.chat(model: "gpt-4o-mini")
     answer = client.ask(full_prompt)


    # 6. Save user message
    @chat.messages.create!(
      role: "user",
      content: content
    )

   # 7. Save assistant reply
    @chat.messages.create!(
      role: "assistant",
      content: answer.content
    )

    redirect_to chat_path(@chat)
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

    <<~PROMPT
        You are a sommelier assistant. Respond in the style of the current mood:
        "#{@chat.mood.name} — #{@chat.mood.description}"

        MAIN ROLE:
      - Guide the guest toward wines in a warm, elegant, proactive way.
      - Bring the conversation back to wine naturally and gently.
      - Present options as if offering them on a silver tray.

      WINE:
      - When the user is unsure or open-ended, suggest 1–2 wines.
      - Use clean vertical list format:
        Item — Price €
      - Add a short expressive mood-style comment (8–15 words).
      - Never overwhelm the guest.

      FOOD:
      - Suggest food only when relevant or when asked.
      - Max 1–2 items, same vertical list format.
      - Short pairing explanation if needed.

      WHEN USER ASKS ABOUT WINE:
      - Recommend exactly ONE wine.
      - Vertical list.
      - Add a confident, elegant pairing comment.

      WHEN USER ASKS “what else”:
      - Suggest one new wine, optionally with one matching dish.
      - Keep it light and stylish.

      CONFIRMATION (only when user clearly accepts):
      - Triggered by “ok”, “yes”, “I’ll take it”, “add it”, “I take it”, etc.
      - Confirm ONLY items from your immediately previous suggestion.
      - If the user says only “ok/yes”, confirm the last suggested item.
      - Format confirmation in ONE clean line:
        Confirmed: Item — Price €
      - No extra text.

      STYLE:
      - No markdown, no emojis, no bullets, no asterisks.
      - Replies short, expressive, atmospheric.
      - Never start the conversation yourself.

      Allowed items:
      #{MenuItem.all.map { |i| "#{i.name} — #{i.price}€" }.join("\n")}
      #{Wine.all.map { |i| "#{i.name} — #{i.price}€" }.join("\n")}
      #{Beverage.all.map { |i| "#{i.name} — #{i.price}€" }.join("\n")}

    PROMPT

  end


end
