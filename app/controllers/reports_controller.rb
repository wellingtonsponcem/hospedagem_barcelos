class ReportsController < ApplicationController
  before_action :require_login

  def index
    # Basic counts
    @total_rooms = Room.count
    @occupied_rooms = Room.where(status: "occupied").count
    @available_rooms = Room.where(status: "available").count
    @total_guests = Guest.count

    # Month filter/summaries
    @month_reservations = Reservation.where("check_in >= ? AND check_in <= ?", Date.today.beginning_of_month, Date.today.end_of_month)
    @month_revenue = @month_reservations.sum(:amount)
    @today_showers = Shower.where("created_at >= ?", Date.today.beginning_of_day)
    @shower_revenue = @today_showers.sum(:value)
    
    # Payment methods breakdown today
    @payment_methods = Transaction.where(created_at: Date.today.beginning_of_day..Date.today.end_of_day)
                                  .group(:payment_method).sum(:value)

    # 1. Performance KPIs calculations
    @occupancy_rate = @total_rooms > 0 ? (@occupied_rooms.to_f / @total_rooms * 100).round(1) : 0
    
    # Month shower revenue
    @month_shower_revenue = Shower.where("created_at >= ? AND created_at <= ?", Date.today.beginning_of_month, Date.today.end_of_month).sum(:value)
    @month_total_revenue = @month_revenue + @month_shower_revenue

    # Average Daily Rate (ADR)
    res_count = @month_reservations.count
    @adr = res_count > 0 ? (@month_revenue / res_count).to_f.round(2) : 0

    # Revenue Per Available Room (RevPAR)
    @revpar = (@adr * (@occupancy_rate / 100.0)).round(2)

    # 2. Monthly Revenue Evolution (Last 6 months)
    @monthly_evolution = []
    (0..5).to_a.reverse.each_with_index do |i, idx|
      start_date = Date.today.beginning_of_month - i.months
      end_date = start_date.end_of_month
      month_name = I18n.l(start_date, format: "%b").upcase
      
      db_revenue = Reservation.where(check_in: start_date..end_date).sum(:amount) +
                   Shower.where(created_at: start_date..end_date).sum(:value)
      
      val = db_revenue.to_f > 0 ? db_revenue.to_f : 0
      @monthly_evolution << { month: month_name, value: val }
    end

    # 3. Proportion of Stays by Type (Paid, Internal, Courtesy)
    res_by_type = Reservation.group(:reservation_type).count
    total_res = res_by_type.values.sum.to_f
    @res_type_percentages = {
      paga: total_res > 0 ? ((res_by_type["paga"] || 0) / total_res * 100).round : 0,
      interna: total_res > 0 ? ((res_by_type["interna"] || 0) / total_res * 100).round : 0,
      cortesia: total_res > 0 ? ((res_by_type["cortesia"] || 0) / total_res * 100).round : 0
    }

    days_in_month = Time.days_in_month(Date.today.month, Date.today.year)
    guest_nights = @month_reservations.sum { |r| r.guest_id.present? ? 1 : 0 }
    @month_guest_avg = days_in_month > 0 ? (guest_nights.to_f / days_in_month).round(1) : 0
  end
end
