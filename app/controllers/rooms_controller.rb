class RoomsController < ApplicationController
  before_action :require_login

  def index
    @rooms = Room.order(:number)
    @available_count = Room.where(status: "available").count
    @occupied_count = Room.where(status: "occupied").count
    @maintenance_count = Room.where(status: "maintenance").count
    @reserved_count = Room.where(status: "reserved").count
  end

  def create
    @room = Room.new(room_params)
    if @room.save
      redirect_to rooms_path, notice: "Quarto cadastrado com sucesso!"
    else
      redirect_to rooms_path, alert: "Erro ao cadastrar: #{@room.errors.full_messages.join(", ")}"
    end
  end

  def update
    @room = Room.find(params[:id])
    if @room.update(room_params)
      redirect_to rooms_path, notice: "Quarto atualizado!"
    else
      redirect_to rooms_path, alert: "Erro ao atualizar: #{@room.errors.full_messages.join(", ")}"
    end
  end

  def destroy
    @room = Room.find(params[:id])
    @room.destroy
    redirect_to rooms_path, notice: "Quarto removido."
  end

  private

  def room_params
    params.require(:room).permit(:number, :name, :capacity, :room_type, :price_1p, :price_2p, :status, :notes, :active)
  end
end
