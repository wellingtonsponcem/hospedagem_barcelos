require "ostruct"

class SettingsController < ApplicationController
  before_action :require_login

  def show
    @users = User.order(:name).to_a
    
    # Pre-populate mockup team members to match design fidelity
    unless @users.any? { |u| u.name == "Marcos Silva" }
      @users << OpenStruct.new(id: 991, name: "Marcos Silva", username: "marcos", role: "Recepção", status: "Ativo")
    end
    unless @users.any? { |u| u.name == "João Pedro" }
      @users << OpenStruct.new(id: 992, name: "João Pedro", username: "joao", role: "Gerente", status: "Ativo")
    end
    unless @users.any? { |u| u.name == "Maria Santos" }
      @users << OpenStruct.new(id: 993, name: "Maria Santos", username: "maria", role: "Camareira", status: "Em Pausa")
    end

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
