# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require "faker"

puts "Cleaning database..."
OrderItem.destroy_all
MenuItem.destroy_all
Wine.destroy_all
Beverage.destroy_all
Mood.destroy_all
User.destroy_all if defined?(User)

puts "Creating 20 wines..."

AUSTRIAN_WINES = [
  { name: "Hiedler Grüner Veltliner Kamptal", category: "White", country: "Austria", price: 28 },
  { name: "Bründlmayer Riesling Heiligenstein", category: "White", country: "Austria", price: 34 },
  { name: "Markowitsch Pinot Noir Carnuntum", category: "Red", country: "Austria", price: 39 },
  { name: "Pöckl Admiral Neusiedlersee", category: "Red", country: "Austria", price: 52 },
  { name: "Schloss Gobelsburg Brut Reserve", category: "Sparkling", country: "Austria", price: 45 }
]

FRENCH_WINES = [
  { name: "Château Margaux Grand Cru", category: "Red", country: "France", price: 150 },
  { name: "Domaine Leflaive Puligny-Montrachet", category: "White", country: "France", price: 95 },
  { name: "Château Mouton Rothschild Pauillac", category: "Red", country: "France", price: 180 },
  { name: "Château d´Yquem Sauternes", category: "Dessert", country: "France", price: 120 },
  { name: "Château Haut-Brion Pessac-Léognan", category: "Red", country: "France", price: 160 },
  { name: "Louis Jadot Chardonnay Bourgogne", category: "White", country: "France", price: 48 },
  { name: "Château de Beaucastel Châteauneuf-du-Pape", category: "Red", country: "France", price: 70 },
  { name: "Domaines Ott Rosé Côtes de Provence", category: "Rosé", country: "France", price: 55 },
  { name: "Billecart-Salmon Brut Réserve Champagne", category: "Sparkling", country: "France", price: 68 },
  { name: "Chablis Premier Cru Montmains", category: "White", country: "France", price: 60 }
]

ITALIAN_WINES = [
  { name: "Antinori Tignanello Toscana", category: "Red", country: "Italy", price: 90 },
  { name: "Gaja Barbaresco Piemonte", category: "Red", country: "Italy", price: 110 },
  { name: "Planeta Chardonnay Sicilia", category: "White", country: "Italy", price: 40 },
  { name: "Frescobaldi Nipozzano Chianti Rufina Riserva", category: "Red", country: "Italy", price: 38 },
  { name: "Ca’ dei Frati Lugana I Frati DOC", category: "White", country: "Italy", price: 33 }
]

WINES = AUSTRIAN_WINES + FRENCH_WINES + ITALIAN_WINES

VOLUMES = ["1/8l", "1/4l", "0.75l"]

WINES.each do |wine|
  Wine.create!(
    name: wine[:name],
    category: wine[:category],
    country: wine[:country],
    description: Faker::Lorem.sentence(word_count: 10),
    price: wine[:price],
    volume: VOLUMES.sample
  )
end

puts "Creating 10 Italian dishes..."

ITALIAN_DISHES = [
  "Bruschetta al Pomodoro",
  "Tagliatelle al Tartufo",
  "Risotto ai Funghi Porcini",
  "Carpaccio di Manzo",
  "Lasagna alla Bolognese",
  "Melanzane alla Parmigiana",
  "Spaghetti alle Vongole",
  "Gnocchi al Gorgonzola",
  "Vitello Tonnato",
  "Tiramisu Classico"
]

ITALIAN_DISHES.each do |dish|
  MenuItem.create!(
    name: dish,
    description: "Authentic Italian dish crafted to complement premium wines. #{Faker::Food.description}",
    price: rand(12.0..28.0).round(2),
  )
end

puts "Creating 10 non-alcoholic beverages..."

DRINKS = [
  "Vöslauer prickelnd 0.33l",
  "Vöslauer still 0.75l",
  "Coca Cola 0.33l",
  "Coca Cola Zero 0.33l",
  "Hollerblütensirup gespritzt 0.5l",
  "Apfelsaft naturtrüb 0.25l",
  "Apfelsaft gespritzt 0.5l",
  "Birnennektar 0.25l",
  "Marillennektar 0.25l",
  "Soda Zitrone 0.25l"
]

DRINKS.each do |drink|
  Beverage.create!(
    name: drink,
    category: "Non-Alcoholic",
    description: "Refreshing Austrian beverage served chilled. #{Faker::Lorem.sentence(word_count: 8)}",
    price: rand(2.5..5.5).round(2),
    volume: drink.scan(/\d+(\.\d+)?l/).flatten.first || "0.25l"
  )
end

puts "Creating default user..."
User.create!(email: "test@example.com", password: "password123") if defined?(User)


puts "Creating 3 amazing sommeliers..."
Mood.create!([
  {
    name: "The Romantic Sommelier",
    description: "Speaks like a soft melody in candlelight — gentle, inviting, and just a little daring. Poetic and attentive, enjoys describing aromas as if they were feelings. Warm, sincere, slightly flirtatious; believes every pairing is a story about chemistry. Prefers Rosé, Prosecco, Burrata, Bruschetta — light, fresh, and delicate pairings.",
  },
  {
    name: "The Classic Sommelier",
    description: "Calm, grounded, and timeless. Believes wine should speak for itself — and knows how to listen. Reliable and warm, with dry humor and deep knowledge. Prefers Pinot Noir, Chianti, truffle pasta, risotto — comfort food with soul.",
  },
  {
    name: "The Rock Sommelier",
    description: "Energetic, witty, and fearless. Turns pairing into performance — loud, bold, and impossible to forget. Creative and rebellious, thrives on surprise. Prefers Amarone, spicy Carpaccio, oysters, and daring combinations that wake the senses.",
  }
])

puts "✅ Seeding completed successfully!"
