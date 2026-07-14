class TransactionsController < ApplicationController
  before_action :require_login

  def index
    redirect_to cash_registers_path
  end

  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.status = "completed"

    if @transaction.save
      redirect_to cash_registers_path, notice: "Transação registrada!"
    else
      redirect_to cash_registers_path, alert: "Erro: #{@transaction.errors.full_messages.join(', ')}"
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:transaction_type, :origin, :description, :value, :payment_method, :responsible, :cash_register_id, :reservation_id)
  end
end
