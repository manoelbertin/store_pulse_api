FactoryBot.define do
  factory :line_item do
    quantity { 1 }
    payed_price { 150.00 }
    status { :waiting_allocation }
    association :order
    association :product
  end
end
