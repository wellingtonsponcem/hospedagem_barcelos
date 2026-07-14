class Transaction < ApplicationRecord
  belongs_to :cash_register, optional: true
  belongs_to :reservation, optional: true

  validates :transaction_type, presence: true
  validates :origin, presence: true
  validates :value, presence: true, numericality: true
end
