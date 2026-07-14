class ReportsController < ApplicationController
  before_action :require_login

  def index
    @total_rooms = Room.count
    @occupied_rooms = Room.where(status: "occupied").count
    @available_rooms = Room.where(status: "available").count
    @total_guests = Guest.count
    @month_reservations = Reservation.where("check_in >= ? AND check_in <= ?", Date.today.beginning_of_month, Date.today.end_of_month)
    @month_revenue = @month_reservations.sum(:amount)
    @today_showers = Shower.where("created_at >= ?", Date.today.beginning_of_day)
    @shower_revenue = @today_showers.sum(:value)
    @payment_methods = Transaction.where(created_at: Date.today.beginning_of_day..Date.today.end_of_day)
                                  .group(:payment_method).sum(:value)
  end
end
