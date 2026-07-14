class Reservation < ApplicationRecord
  belongs_to :room
  belongs_to :guest

  validates :check_in, presence: true
  validates :check_out, presence: true
end
