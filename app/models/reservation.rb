class Reservation < ApplicationRecord
  belongs_to :room
  belongs_to :guest
  has_many :transactions, dependent: :nullify

  validates :check_in, presence: true
  validates :check_out, presence: true

  scope :active, -> { where(status: [ "confirmed", "checked_in" ]) }
  scope :today, -> { where(check_in: Date.today.beginning_of_day..Date.today.end_of_day) }
  scope :current, -> { where("check_in <= ? AND check_out >= ?", Time.current, Time.current) }

  def duration_hours
    ((check_out - check_in) / 3600).round
  end

  def duration_days
    (check_out.to_date - check_in.to_date).to_i
  end

  def status_text
    I18n.t("reservation.statuses.#{status}", default: status.humanize)
  end

  def total_charges
    transactions.sum(:value)
  end

  def balance
    (amount || 0) + total_charges
  end
end
