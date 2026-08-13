FactoryBot.define do
  factory :order do
    status { :processing }
    subtotal { 199.90 }
    total_amount { 199.90 }
    payment_type { :credit_card }
    installments { 1 }
    association :user
  end
end
