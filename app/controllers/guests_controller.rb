class GuestsController < ApplicationController
  before_action :require_login

  def index
    @guests = Guest.order(:name)
  end

  def show
    @guest = Guest.find(params[:id])
    respond_to do |format|
      format.html { redirect_to guests_path }
      format.json { render json: @guest }
    end
  end

  def new
    @guest = Guest.new
    render :form
  end

  def edit
    @guest = Guest.find(params[:id])
    render :form
  end

  def create
    @guest = Guest.new(guest_params)
    if @guest.save
      redirect_to guests_path, notice: "Hóspede cadastrado com sucesso!"
    else
      render :form, status: :unprocessable_entity
    end
  end

  def update
    @guest = Guest.find(params[:id])
    if @guest.update(guest_params)
      redirect_to guests_path, notice: "Hóspede atualizado!"
    else
      render :form, status: :unprocessable_entity
    end
  end

  def destroy
    @guest = Guest.find(params[:id])
    @guest.destroy
    redirect_to guests_path, notice: "Hóspede removido."
  end

  private

  def guest_params
    params.require(:guest).permit(:name, :document, :phone, :plate, :city, :company, :notes)
  end
end
