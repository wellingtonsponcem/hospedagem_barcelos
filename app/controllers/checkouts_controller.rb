class CheckoutsController < ApplicationController
  before_action :require_login

  def show
    @reservation = Reservation.find(params[:id])
    @room = @reservation.room
    @guest = @reservation.guest
    calculator = ReservationCheckoutCalculator.new(@reservation)
    @total = calculator.calculate
    @transactions = @reservation.transactions.order(created_at: :desc)
    render :show
  end

  def update
    @reservation = Reservation.find(params[:id])
    @room = @reservation.room
    
    if @reservation.update(status: "checked_out")
      @room.update!(status: "inspection")
      redirect_to rooms_path, notice: "Check-out do Quarto #{@room.number} realizado e enviado para vistoria!"
    else
      redirect_to checkout_path(@reservation), alert: "Erro ao finalizar check-out: #{@reservation.errors.full_messages.join(', ')}"
    end
  end
end
