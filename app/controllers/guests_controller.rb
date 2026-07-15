class GuestsController < ApplicationController
  before_action :require_login

  def index
    @guests = Guest.order(:name)
    if params[:active_id].present?
      @selected_guest = Guest.find_by(id: params[:active_id])
    end
    @selected_guest ||= @guests.first
  end

  def show
    @guest = Guest.find(params[:id])
    respond_to do |format|
      format.html { redirect_to guests_path(active_id: @guest.id) }
      format.json do
        render json: @guest.as_json(
          methods: [ :initials, :status, :occurrences ],
          include: {
            reservations: {
              include: :room,
              methods: [ :duration_days ]
            }
          }
        )
      end
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
      redirect_to guests_path(active_id: @guest.id), notice: "Hóspede cadastrado com sucesso!"
    else
      redirect_to guests_path, alert: "Erro ao cadastrar: #{@guest.errors.full_messages.join(', ')}"
    end
  end

  def update
    @guest = Guest.find(params[:id])
    if @guest.update(guest_params)
      redirect_to guests_path(active_id: @guest.id), notice: "Hóspede atualizado com sucesso!"
    else
      redirect_to guests_path(active_id: @guest.id), alert: "Erro ao atualizar: #{@guest.errors.full_messages.join(', ')}"
    end
  end

  def destroy
    @guest = Guest.find(params[:id])
    @guest.destroy
    redirect_to guests_path, notice: "Hóspede removido com sucesso."
  end

  private

  def guest_params
    params.require(:guest).permit(:name, :document, :phone, :plate, :city, :company, :notes)
  end
end
