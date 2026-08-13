class LineItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  has_many :licenses, dependent: :destroy

  enum :status, { waiting_allocation: 0, allocated: 1 }

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :payed_price, presence: true, numericality: { greater_than: 0 }
end
