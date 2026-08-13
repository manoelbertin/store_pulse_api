class Product < ApplicationRecord
  include Searchable
  include Paginatable

  belongs_to :productable, polymorphic: true

  has_one_attached :image

  has_many :product_categories, dependent: :destroy
  has_many :categories, through: :product_categories
  has_many :line_items, dependent: :restrict_with_error
  has_many :wish_items, dependent: :destroy

  enum :status, { available: 1, unavailable: 2 }

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true
  validates :featured, presence: true
  validates :image, presence: true

  def sells_count
    line_items.joins(:order)
    .where(orders: { status: [:completed, :finished] })
    .sum(:quantity)
  end
end
