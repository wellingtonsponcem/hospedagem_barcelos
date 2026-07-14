class ReservationCheckoutCalculator
  def initialize(reservation)
    @reservation = reservation
  end

  def calculate
    room_charge + extra_charges
  end

  def room_charge
    days = @reservation.duration_days
    days = 1 if days < 1
    days * @reservation.room.price_1p
  end

  def extra_charges
    @reservation.transactions.sum(:value)
  end

  def breakdown
    {
      room_charge: room_charge,
      extra_charges: extra_charges,
      total: calculate
    }
  end
end
