class CashRegistersController < ApplicationController
  before_action :require_login

  def index
    @current_cash_register = CashRegister.where(status: "open").last
    @cash_registers = CashRegister.order(created_at: :desc).limit(30)
    @cash_register = CashRegister.new

    if @current_cash_register
      @today_transactions = @current_cash_register.transactions.order(created_at: :desc)
      @total_in = @today_transactions.where(transaction_type: [ "receita", "recebimento" ]).sum(:value)
      @total_out = @today_transactions.where(transaction_type: [ "despesa", "retirada" ]).sum(:value)
      @balance = @current_cash_register.opening_balance + @total_in - @total_out

      # Breakdown for physical reconciliation modal (Fechamento)
      @pix_in = @today_transactions.where(payment_method: "PIX", transaction_type: [ "receita", "recebimento" ]).sum(:value)
      @credit_in = @today_transactions.where(payment_method: "Cartão Crédito", transaction_type: [ "receita", "recebimento" ]).sum(:value)
      @debit_in = @today_transactions.where(payment_method: "Cartão Débito", transaction_type: [ "receita", "recebimento" ]).sum(:value)
      @cash_in = @today_transactions.where(payment_method: "Dinheiro", transaction_type: [ "receita", "recebimento" ]).sum(:value)
    end
  end

  def create
    @cash_register = CashRegister.new(cash_register_params)
    @cash_register.opened_at = Time.current
    @cash_register.status = "open"

    if @cash_register.save
      redirect_to cash_registers_path, notice: "Caixa aberto com saldo de #{number_to_currency(@cash_register.opening_balance)}."
    else
      @current_cash_register = nil
      @cash_registers = CashRegister.order(created_at: :desc).limit(30)
      render :index, status: :unprocessable_entity
    end
  end

  def update
    @cash_register = CashRegister.find(params[:id])
    if @cash_register.update(cash_register_params)
      redirect_to cash_registers_path, notice: "Caixa atualizado."
    else
      redirect_to cash_registers_path, alert: "Erro ao atualizar."
    end
  end

  def close
    @cash_register = CashRegister.find(params[:id])
    @cash_register.update!(
      status: "closed",
      closed_at: Time.current,
      closing_balance: params[:closing_balance]
    )
    redirect_to cash_registers_path, notice: "Caixa fechado com sucesso."
  end

  private

  def cash_register_params
    params.require(:cash_register).permit(:opening_balance)
  end
end
