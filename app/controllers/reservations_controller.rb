class ReservationsController < ApplicationController
  before_action :require_login
  before_action :set_reservation, only: [ :show, :edit, :update, :destroy, :checkin, :checkout ]

  def index
    @reservations = Reservation.order(check_in: :desc)
    @current_reservations = Reservation.current.includes(:room, :guest).order(:check_in)
    @today_checkins = Reservation.today.where(status: [ "confirmed", "checked_in" ]).includes(:room, :guest)
  end

  def new
    @reservation = Reservation.new
    @reservation.check_in = Time.current
    @reservation.check_out = 16.hours.from_now
    @rooms = Room.where(status: [ "available", "reserved" ]).order(:number)
    @guests = Guest.order(:name)
  end

  def create
    @reservation = Reservation.new(reservation_params)
    @reservation.status = "confirmed"

    if @reservation.save
      @reservation.room.update!(status: "reserved")
      redirect_to reservations_path, notice: "Reserva criada com sucesso!"
    else
      @rooms = Room.where(status: [ "available", "reserved" ]).order(:number)
      @guests = Guest.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @rooms = Room.order(:number)
    @guests = Guest.order(:name)
  end

  def update
    if @reservation.update(reservation_params)
      redirect_to reservations_path, notice: "Reserva atualizada!"
    else
      @rooms = Room.order(:number)
      @guests = Guest.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @reservation.destroy
    redirect_to reservations_path, notice: "Reserva removida."
  end

  def checkin
    if @reservation.update(status: "checked_in")
      @reservation.room.update!(status: "occupied")
      redirect_to reservations_path, notice: "Check-in realizado!"
    else
      redirect_to reservations_path, alert: "Erro ao realizar check-in."
    end
  end

  def checkout
    calculator = ReservationCheckoutCalculator.new(@reservation)
    @total = calculator.calculate
    @transactions = @reservation.transactions.order(created_at: :desc)
    render :checkout
  end

  private

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def reservation_params
    params.require(:reservation).permit(:room_id, :guest_id, :check_in, :check_out, :reservation_type, :notes, :amount)
  end
end
