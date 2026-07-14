puts "Criando usuário padrão..."
User.find_or_create_by!(username: "admin") do |u|
  u.name = "Administrador"
  u.password = "123456"
end

puts "Criando quartos..."
rooms = [
  { number: "101", name: "Quarto 101", capacity: 2, room_type: "Standard Single", price_1p: 145.00, price_2p: 190.00, status: "available" },
  { number: "102", name: "Quarto 102", capacity: 2, room_type: "Standard Double", price_1p: 145.00, price_2p: 190.00, status: "available" },
  { number: "103", name: "Quarto 103", capacity: 1, room_type: "Standard Single", price_1p: 110.00, price_2p: 0.00, status: "maintenance" },
  { number: "201", name: "Quarto 201", capacity: 2, room_type: "Suíte Luxo", price_1p: 220.00, price_2p: 300.00, status: "available" },
  { number: "202", name: "Quarto 202", capacity: 2, room_type: "Standard Double", price_1p: 145.00, price_2p: 190.00, status: "available" },
  { number: "203", name: "Quarto 203", capacity: 2, room_type: "Standard Double", price_1p: 145.00, price_2p: 190.00, status: "occupied" },
  { number: "VIP 1", name: "Quarto VIP 1", capacity: 2, room_type: "Master Suite", price_1p: 350.00, price_2p: 450.00, status: "available" },
]

rooms.each do |attrs|
  Room.find_or_create_by!(number: attrs[:number]) do |r|
    r.assign_attributes(attrs)
  end
end

puts "Seed concluído! #{Room.count} quartos criados."
