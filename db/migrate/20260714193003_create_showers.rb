class CreateShowers < ActiveRecord::Migration[8.1]
  def change
    create_table :showers do |t|
      t.string :guest_name
      t.string :cabin
      t.datetime :start_time
      t.datetime :end_time
      t.decimal :value, precision: 10, scale: 2, default: 20.0
      t.string :payment_method
      t.string :status, default: "active"

      t.timestamps
    end
  end
end
