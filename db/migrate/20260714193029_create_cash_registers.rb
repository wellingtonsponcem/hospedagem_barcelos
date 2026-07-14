class CreateCashRegisters < ActiveRecord::Migration[8.1]
  def change
    create_table :cash_registers do |t|
      t.decimal :opening_balance, precision: 10, scale: 2, default: 0.0
      t.string :status, default: "open"
      t.datetime :opened_at
      t.datetime :closed_at

      t.timestamps
    end
  end
end
