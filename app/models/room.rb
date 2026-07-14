class Room < ApplicationRecord
  STATUSES = [ "available", "occupied", "reserved", "maintenance", "cleaning", "inspection", "internal" ].freeze

  has_many :reservations, dependent: :nullify

  validates :number, presence: true, uniqueness: true
  validates :name, presence: true
  validates :capacity, presence: true, numericality: { greater_than: 0 }
  validates :status, inclusion: { in: STATUSES }

  def active_reservation
    reservations.find_by(status: "checked_in")
  end

  def upcoming_reservation
    reservations.where(status: "confirmed").where("check_in >= ?", Date.today.beginning_of_day).order(:check_in).first
  end

  def status_color_class
    case status
    when "available" then "bg-green-500"
    when "occupied" then "bg-primary"
    when "reserved" then "bg-secondary"
    when "maintenance" then "bg-red-500"
    when "cleaning" then "bg-blue-300"
    when "inspection" then "bg-orange-400"
    when "internal" then "bg-inverse-surface"
    else "bg-outline"
    end
  end

  def status_badge_class
    case status
    when "available" then "bg-green-100 text-green-800"
    when "occupied" then "bg-primary-container text-on-primary-container"
    when "reserved" then "bg-secondary text-white"
    when "maintenance" then "bg-error text-white"
    when "cleaning" then "bg-blue-400 text-white"
    when "inspection" then "bg-orange-400 text-white"
    when "internal" then "bg-inverse-surface text-white"
    else "bg-surface-variant text-on-surface-variant"
    end
  end

  def status_text
    I18n.t("room.statuses.#{status}", default: status.humanize)
  end
end
