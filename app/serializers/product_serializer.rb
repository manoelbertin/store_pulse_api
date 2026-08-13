class ProductSerializer
  def initialize(product)
    @product = product
  end

  def as_json(*)
    {
      id: @product.id,
      name: @product.name,
      description: @product.description,
      price: @product.price,
      status: @product.status,
      featured: @product.featured
    }
  end
end
