class CreateReservations < ActiveRecord::Migration[8.1]
  def change
    create_table :reservations do |t|
      t.references :room, null: false, foreign_key: true
      t.references :guest, null: false, foreign_key: true
      t.datetime :check_in, null: false
      t.datetime :check_out, null: false
      t.string :reservation_type, default: "paga"
      t.string :status, default: "confirmed"
      t.text :notes

      t.timestamps
    end
  end
end
