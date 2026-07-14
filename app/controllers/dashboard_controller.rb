class DashboardController < ApplicationController
  before_action :require_login

  def index
    @total_rooms = Room.count
    @available_rooms = Room.where(status: "available").count
    @occupied_rooms = Room.where(status: "occupied").count
    @maintenance_rooms = Room.where(status: "maintenance").count
    @reserved_rooms = Room.where(status: "reserved").count

    @current_guests = Reservation.current.includes(:room, :guest).limit(5)
    @today_checkins = Reservation.today.where(status: [ "confirmed", "checked_in" ]).count
    @today_checkouts = Reservation.where("check_out >= ? AND check_out <= ?", Date.today.beginning_of_day, Date.today.end_of_day).count
    @active_showers = Shower.where(status: "active").count
    @today_revenue = Transaction.where("created_at >= ?", Date.today.beginning_of_day).sum(:value)
  end
end
