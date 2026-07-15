class SettingsController < ApplicationController
  before_action :require_login

  def show
    @users = User.order(:name).to_a

    @rooms = Room.order(:number)
    @available_count = Room.where(status: "available").count
    @occupied_count = Room.where(status: "occupied").count
    @maintenance_count = Room.where(status: "maintenance").count
    @reserved_count = Room.where(status: "reserved").count

    # Pre-build dummy new room for the category drawer form
    @room = Room.new
  end

  def update
    file_path = Rails.root.join("config", "settings.json")
    
    updated_settings = {
      "price_standard" => params[:price_standard],
      "price_executiva" => params[:price_executiva],
      "price_shower" => params[:price_shower],
      "price_towel" => params[:price_towel],
      "price_other" => params[:price_other]
    }
    
    File.write(file_path, JSON.pretty_generate(updated_settings))
    
    redirect_to settings_path(tab: params[:tab] || 'financeiro'), notice: "Configurações atualizadas com sucesso."
  end
end
