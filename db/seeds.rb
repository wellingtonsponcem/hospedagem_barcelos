if Rails.env.local?
  puts "Limpando banco de dados..."
  Transaction.destroy_all
  Reservation.destroy_all
  Room.destroy_all
  Guest.destroy_all
  Shower.destroy_all
  CashRegister.destroy_all
  User.destroy_all
end

unless User.exists?
  puts "Criando usuário padrão..."
  User.create!(name: "Administrador", username: "admin", password: "123456")
end

unless Guest.exists?
  puts "Criando hóspedes..."
  marcos = Guest.create!(name: "Marcos Oliveira", document: "123.456.789-00", phone: "(11) 99999-8888", city: "São Paulo / SP")
  ana = Guest.create!(name: "Ana Paula J.", document: "987.654.321-11", phone: "(11) 98888-7777", city: "São Paulo / SP")
  carlos = Guest.create!(name: "Carlos Henrique", document: "456.123.789-22", phone: "(21) 97777-6666", city: "Rio de Janeiro / RJ")
  julia = Guest.create!(name: "Julia Camareira", document: "111.222.333-44", phone: "(31) 96666-5555", city: "Belo Horizonte / MG")
end

unless Room.exists?
  puts "Criando quartos..."
  rooms_data = [
    { number: "01", name: "Quarto 01", capacity: 2, room_type: "Standard Single", price_1p: 145.00, price_2p: 190.00, status: "occupied", active: true },
    { number: "02", name: "Quarto 02", capacity: 2, room_type: "Standard Double", price_1p: 145.00, price_2p: 190.00, status: "available", active: true },
    { number: "03", name: "Quarto 03", capacity: 2, room_type: "Standard Double", price_1p: 145.00, price_2p: 190.00, status: "reserved", active: true },
    { number: "04", name: "Quarto 04", capacity: 2, room_type: "Suíte Luxo", price_1p: 220.00, price_2p: 300.00, status: "maintenance", active: true },
    { number: "05", name: "Quarto 05", capacity: 2, room_type: "Standard Double", price_1p: 145.00, price_2p: 190.00, status: "available", active: true },
    { number: "06", name: "Quarto 06", capacity: 2, room_type: "Standard Double", price_1p: 145.00, price_2p: 190.00, status: "occupied", active: true },
    { number: "07", name: "Quarto 07", capacity: 2, room_type: "Master Suite", price_1p: 350.00, price_2p: 450.00, status: "available", active: true }
  ]

  rooms = {}
  rooms_data.each do |attrs|
    rooms[attrs[:number]] = Room.create!(attrs)
  end

  puts "Criando caixa diário..."
  cash_register = CashRegister.create!(opened_at: Time.current.beginning_of_day, opening_balance: 1000.00, status: "open")

  puts "Criando reservas..."
  marcos = Guest.find_by!(name: "Marcos Oliveira")
  ana = Guest.find_by!(name: "Ana Paula J.")
  carlos = Guest.find_by!(name: "Carlos Henrique")

  res1 = Reservation.create!(
    room: rooms["01"], guest: marcos,
    check_in: Time.current.beginning_of_day - 1.day + 12.hours,
    check_out: Time.current.beginning_of_day + 12.hours,
    status: "checked_in", amount: 190.00, paid: false, reservation_type: "paga"
  )

  res3 = Reservation.create!(
    room: rooms["03"], guest: ana,
    check_in: Time.current.beginning_of_day + 14.hours + 30.minutes,
    check_out: Time.current.beginning_of_day + 2.days + 12.hours,
    status: "confirmed", amount: 150.00, paid: true, reservation_type: "paga"
  )

  res6 = Reservation.create!(
    room: rooms["06"], guest: carlos,
    check_in: Time.current.beginning_of_day - 2.days + 14.hours,
    check_out: Time.current.beginning_of_day + 18.hours,
    status: "checked_in", amount: 380.00, paid: true, reservation_type: "paga"
  )

  Transaction.create!(
    cash_register: cash_register, reservation: res6,
    transaction_type: "credit", origin: "interna", value: 380.00,
    description: "Hospedagem Quarto 06", responsible: "Ricardo Silva", status: "completed"
  )

  puts "Criando banho avulso..."
  Shower.create!(
    cabin: "02", guest_name: "Marcos Silva", status: "active",
    start_time: Time.current - 1.hour, end_time: Time.current - 30.minutes,
    value: 20.00, payment_method: "pix"
  )
end

puts "Seed concluído! #{Room.count} quartos, #{Guest.count} hóspedes, #{Reservation.count} reservas."
