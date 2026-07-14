class AddReservationToTransactions < ActiveRecord::Migration[8.1]
  def change
    add_reference :transactions, :reservation, null: false, foreign_key: true
  end
end
