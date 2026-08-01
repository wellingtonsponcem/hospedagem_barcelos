class ReleaseStaleRoomStatuses < ActiveRecord::Migration[8.1]
  def up
    Room.where(status: "reserved").find_each do |room|
      next if room.upcoming_reservation
      room.update!(status: "available")
      puts "Quarto #{room.number} liberado: reserva sem check-in (no-show)"
    end

    Room.where(status: "occupied").find_each do |room|
      next if room.active_reservation
      room.update!(status: "available")
      puts "Quarto #{room.number} liberado: sem hóspede ativo"
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
