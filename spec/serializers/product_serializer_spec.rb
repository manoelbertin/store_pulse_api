require 'rails_helper'

RSpec.describe ProductSerializer do
  let(:product) { create(:product) }

  it 'serializes the product attributes' do
    json = ProductSerializer.new(product).as_json

    expect(json[:id]).to eq(product.id)
    expect(json[:name]).to eq(product.name)
    expect(json[:description]).to eq(product.description)
    expect(json[:price].to_s).to eq(product.price.to_s)
    expect(json[:featured]).to eq(product.featured)
  end
end
