class AddPaidToReservations < ActiveRecord::Migration[8.1]
  def change
    add_column :reservations, :paid, :boolean, default: false
  end
end
