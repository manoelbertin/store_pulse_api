class SystemRequirement < ApplicationRecord
  include Searchable
  include Paginatable

  has_many :games, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :operational_system, :storage, :processor, :memory, :video_board, presence: true
end
