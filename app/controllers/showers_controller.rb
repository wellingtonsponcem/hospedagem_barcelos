class ShowersController < ApplicationController
  before_action :require_login

  def index
    @active_showers = Shower.where(status: "active").order(created_at: :desc)
    @today_showers = Shower.where("created_at >= ?", Date.today.beginning_of_day).order(created_at: :desc)
    @shower = Shower.new
  end

  def create
    @shower = Shower.new(shower_params)
    @shower.start_time = Time.current
    @shower.status = "active"

    if @shower.save
      redirect_to showers_path, notice: "Banho iniciado para #{@shower.guest_name}."
    else
      @active_showers = Shower.where(status: "active").order(created_at: :desc)
      @today_showers = Shower.where("created_at >= ?", Date.today.beginning_of_day).order(created_at: :desc)
      render :index, status: :unprocessable_entity
    end
  end

  def update
    @shower = Shower.find(params[:id])
    if @shower.update(shower_params)
      redirect_to showers_path, notice: "Banho atualizado."
    else
      redirect_to showers_path, alert: "Erro ao atualizar."
    end
  end

  def finish
    @shower = Shower.find(params[:id])
    @shower.update!(end_time: Time.current, status: "finished")
    redirect_to showers_path, notice: "Banho finalizado."
  end

  private

  def shower_params
    params.require(:shower).permit(:guest_name, :cabin, :value, :payment_method)
  end
end
