class License < ApplicationRecord
  belongs_to :game
  belongs_to :line_item, optional: true

  enum :status, { available: 0, in_use: 1, inactive: 2 }
  enum :platform, { steam: 0, origin: 1, psn: 2, xbox: 3 }

  validates :key, presence: true
end
