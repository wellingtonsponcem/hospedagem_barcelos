class Shower < ApplicationRecord
  validates :guest_name, presence: true
  validates :cabin, presence: true
  validates :value, numericality: { greater_than_or_equal_to: 0 }
end
