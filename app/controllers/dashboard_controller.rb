class DashboardController < ApplicationController
  before_action :require_login

  def index
    @total_rooms = Room.count
    @available_rooms = Room.where(status: "available").count
    @occupied_rooms = Room.where(status: "occupied").count
    @maintenance_rooms = Room.where(status: "maintenance").count
    @reserved_rooms = Room.where(status: "reserved").count
  end
end
