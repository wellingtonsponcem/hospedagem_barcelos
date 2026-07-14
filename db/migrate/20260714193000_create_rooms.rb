class CreateRooms < ActiveRecord::Migration[8.1]
  def change
    create_table :rooms do |t|
      t.string :number, null: false
      t.string :name, null: false
      t.integer :capacity, null: false, default: 2
      t.string :room_type
      t.decimal :price_1p, precision: 10, scale: 2, default: 0.0
      t.decimal :price_2p, precision: 10, scale: 2, default: 0.0
      t.string :status, null: false, default: "available"
      t.text :notes
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :rooms, :number, unique: true
  end
end
