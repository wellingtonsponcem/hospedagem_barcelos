class Guest < ApplicationRecord
  has_many :reservations, dependent: :nullify

  validates :name, presence: true

  def initials
    name.split.map(&:first).first(2).join.upcase
  end

  def status
    if reservations.where(status: "checked_in").exists?
      "in_stay"
    elsif notes.to_s.downcase.include?("alerta") || reservations.where("notes LIKE ?", "%alerta%").exists?
      "alert"
    elsif reservations.where(status: "checked_out").count >= 3
      "loyal"
    else
      "inactive"
    end
  end

  def occurrences
    occurrences_list = []
    reservations.each do |res|
      if res.notes.present? && (res.notes.downcase.include?("sumi") || res.notes.downcase.include?("quebro") || res.notes.downcase.include?("danific") || res.notes.downcase.include?("esquec") || res.notes.downcase.include?("falta"))
        occurrences_list << {
          title: res.notes.truncate(30),
          description: "Reserva no Quarto #{res.room.number} em #{res.check_in.strftime('%d/%m/%Y')}. Detalhes: #{res.notes}"
        }
      end
    end
    occurrences_list
  end
end
