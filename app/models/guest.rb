class Guest < ApplicationRecord
  validates :name, presence: true

  def initials
    name.split.map(&:first).first(2).join.upcase
  end
end
