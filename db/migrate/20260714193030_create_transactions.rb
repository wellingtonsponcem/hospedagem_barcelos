class CreateTransactions < ActiveRecord::Migration[8.1]
  def change
    create_table :transactions do |t|
      t.string :transaction_type, null: false
      t.string :origin, null: false
      t.string :description
      t.decimal :value, precision: 10, scale: 2, null: false, default: 0.0
      t.string :payment_method
      t.string :responsible
      t.string :status, default: "pending"
      t.references :cash_register, foreign_key: true, null: true

      t.timestamps
    end
  end
end
