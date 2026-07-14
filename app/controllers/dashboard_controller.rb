class DashboardController < ApplicationController
  before_action :require_login

  def index
    @rooms = Room.order(:number)

    @available_rooms = Room.where(status: "available").count
    @occupied_rooms = Room.where(status: "occupied").count
    @reserved_rooms = Room.where(status: "reserved").count
    @maintenance_rooms = Room.where(status: ["maintenance", "cleaning", "inspection"]).count

    # Alertas Operacionais
    @maintenance_alerts = Room.where(status: ["maintenance", "cleaning", "inspection"]).order(:number)
    @elapsed_showers = Shower.where(status: "active").where("end_time < ?", Time.current)

    # Fluxo do Dia (Timeline)
    today_checkouts = Reservation.where(check_out: Date.today.all_day).includes(:guest, :room)
    today_checkins = Reservation.where(check_in: Date.today.all_day).includes(:guest, :room)

    @timeline_events = []
    today_checkouts.each do |res|
      @timeline_events << {
        time: res.check_out,
        type: :checkout,
        guest_name: res.guest.name,
        room_number: res.room.number,
        details: res.paid ? "Pago" : "Pendente Pagamento",
        reservation: res
      }
    end
    today_checkins.each do |res|
      @timeline_events << {
        time: res.check_in,
        type: :checkin,
        guest_name: res.guest.name,
        room_number: res.room.number,
        details: res.paid ? "Pré-pago" : "Pagar no Check-out",
        reservation: res
      }
    end
    @timeline_events.sort_by! { |e| e[:time] }

    # Receita de hoje (para compatibilidade caso precise em algum KPI futuro)
    @today_revenue = Transaction.where("created_at >= ?", Date.today.beginning_of_day).sum(:value)
  end
end
