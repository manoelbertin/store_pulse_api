class Order < ApplicationRecord
  belongs_to :user
  belongs_to :coupon, optional: true
  has_many :line_items, dependent: :destroy

  enum :status, { processing: 0, completed: 1, finished: 1, canceled: 2 }
  enum :payment_type, { credit_card: 0, billet: 1 }

  validates :status, :subtotal, :total_amount, :payment_type, presence: true
end
