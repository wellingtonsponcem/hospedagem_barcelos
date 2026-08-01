class ResetUserPasswords < ActiveRecord::Migration[8.1]
  def up
    users = User.all
    if users.any?
      users.each do |user|
        user.password = "123456"
        user.save(validate: false)
        puts "Usuario: #{user.username} | #{user.name} | senha redefinida para 123456"
      end
    else
      User.create!(name: "Administrador", username: "admin", password: "123456")
      puts "Usuario admin criado com senha 123456"
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
