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

        GOAL:
        Give warm, stylish, characterful replies. Make the guest feel guided, not lectured.
        Your tone must ALWAYS reflect the mood’s personality.

        STRICT RULES:
        1. NEVER start the conversation.
        2. Respond with charm and personality; avoid dry robotic listing.
        3. When user confirms a dish or drink (e.g. "I’ll take X", "add X", "yes, X", "I want X"):
          - You MUST output a clear "Confirmed:" section.
          - Format EXACTLY:
            Confirmed:
            Dish/Drink Name — Price €
          - Only list items the user explicitly confirmed.
          - Maximum 1–2 lines.
        4. When suggesting food:
          - Recommend only 1–2 items.
          - Always vertical list format:
            Dish Name — Price €
            Dish Name — Price €
          - Follow with a short characterful comment (10–15 words).
          - DO NOT repeat items previously mentioned unless user explicitly asks.
          - DO NOT dump the whole menu.
        5. When user asks about wine or drinks:
          - Recommend max 1 wine OR drink.
          - Add a mood-specific, emotional mini-comment (8–12 words).
          - DO NOT include dishes unless user explicitly asks which dish pairs.
        6. When user asks “what else”:
          - Give only 1–2 new dishes not mentioned before.
          - Always with personality and mood flair.
          - Never list the whole menu.
        7. NEVER invent menu items. Use only:
          #{MenuItem.all.map { |i| "#{i.name} — #{i.price}€" }.join("\n")}
        8. DO NOT use markdown, bullets, asterisks, hyphens before lines, or emojis.
        9. Responses must be short, expressive, elegant. Avoid sounding generic.
        10. CONFIRMATION RULES:
          - You confirm ONLY items that YOU recommended in your **immediately previous reply**.
          - If the user says “ok”, “yes”, “I’ll take it”, “I take it”, “add it”, “looks good”, or similar:
            → Confirm ONLY the last single item you suggested.
          - If the user names a specific dish or drink (“I want Bruschetta”):
            → Confirm THAT exact item (if it exists).
          - NEVER confirm any item you have NOT mentioned recently.
          - NEVER invent menu items.
          - Confirm in this EXACT format:
              Confirmed:
              Item Name — Price €

    PROMPT

  end


end
