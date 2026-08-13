module Admin
  module V1
    class ProductsController < ApplicationController
      include AdminAuthorization

      before_action :set_product, only: %i[show update destroy]
      before_action :authorize_admin_from_header!
      def index
        products = Product.all
        render json: { data: products.map { |p| ProductSerializer.new(p).as_json } }, status: :ok
      end

      def show
        render json: { data: ProductSerializer.new(@product).as_json }, status: :ok
      end

      def create
        @product = build_product_from_params

        # Attach image before saving so presence validation passes
        attach_image(@product)

        if @product.save
          attach_categories(@product)
          render json: { data: ProductSerializer.new(@product).as_json }, status: :created
        else
          render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @product.update(product_params.except(:category_ids, :image, :productable_type, :productable_id))
          attach_categories(@product)
          attach_image(@product)
          render json: { data: ProductSerializer.new(@product).as_json }, status: :ok
        else
          render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @product.destroy
        head :no_content
      end

      private

      # Authorization is handled by the AdminAuthorization concern

      def set_product
        @product = Product.find(params[:id])
      end

      def product_params
        params.require(:product).permit(:name, :description, :price, :status, :featured, :image, :productable_type, :productable_id, category_ids: [])
      end

      def build_product_from_params
        attrs = product_params.except(:category_ids, :image, :productable_type, :productable_id)
        productable = nil
        if product_params[:productable_type].present? && product_params[:productable_id].present?
          productable = product_params[:productable_type].constantize.find(product_params[:productable_id])
        end

        product = Product.new(attrs)
        product.productable = productable if productable
        product
      end

      def attach_categories(product)
        return unless product_params[:category_ids]

        product.category_ids = product_params[:category_ids].reject(&:blank?)
      end

      def attach_image(product)
        return unless product_params[:image]

        product.image.attach(product_params[:image])
      end

      # product_json removed; use ProductSerializer
    end
  end
end
