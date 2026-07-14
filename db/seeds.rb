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

puts "Criando hóspedes..."
guests = [
  { name: "Ricardo Souza", document: "123.456.789-00", phone: "(11) 99999-8888", plate: "ABC-1234", city: "São Paulo / SP", company: "Transportes X Ltda." },
  { name: "Mariana Alves", document: "987.654.321-11", phone: "(11) 98888-7777", plate: "XYZ-9876", city: "São Paulo / SP", company: "Transportes X Ltda." },
  { name: "Carlos Pereira", document: "456.123.789-22", phone: "(21) 97777-6666", plate: "GHI-0099", city: "Rio de Janeiro / RJ", company: "Auto Posto Rio" },
  { name: "Fernanda Lima", document: "321.654.987-44", phone: "(31) 96666-5555", plate: "LMN-5544", city: "Belo Horizonte / MG", company: "Minas Logística" },
]
guests.each do |attrs|
  Guest.find_or_create_by!(name: attrs[:name]) { |g| g.assign_attributes(attrs) }
end

puts "Seed concluído! #{Room.count} quartos, #{Guest.count} hóspedes criados."
