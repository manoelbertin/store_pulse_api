class Game < ApplicationRecord
  include Searchable
  include Paginatable

  belongs_to :system_requirement
  has_one :product, as: :productable, dependent: :destroy
  has_many :licenses, dependent: :destroy

  enum :mode, { pvp: 1, pve: 2, both: 3 }

  validates :mode, :release_date, :developer, presence: true

  def ship!(line_item)
    Admin::AlocateLicenseJob.perform_later(line_item)
  end
end
