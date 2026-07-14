class CreateGuests < ActiveRecord::Migration[8.1]
  def change
    create_table :guests do |t|
      t.string :name, null: false
      t.string :document
      t.string :phone
      t.string :plate
      t.string :city
      t.string :company
      t.text :notes

      t.timestamps
    end
  end
end
