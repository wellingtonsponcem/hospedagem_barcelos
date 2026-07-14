class AddClosingBalanceToCashRegisters < ActiveRecord::Migration[8.1]
  def change
    add_column :cash_registers, :closing_balance, :decimal
  end
end
