require 'rails_helper'

RSpec.describe "Admin::V1::Products", type: :request do
  let(:user) { create(:user, profile: :admin) }
  let!(:game) { create(:game) }
  let!(:categories) { create_list(:category, 2) }

  describe "GET /admin/v1/products" do
    let(:url) { "/admin/v1/products" }
    let!(:products) { create_list(:product, 5) }

    context "quando o usuário é admin autenticado" do
      it "retorna a lista de produtos com status HTTP 200" do
        get url, headers: auth_header(user)
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["data"].size).to eq(5)
      end
    end

    context "quando o usuário não é admin" do
      let(:client_user) { create(:user, profile: :client) }

      it "retorna status HTTP 403 (Forbidden)" do
        get url, headers: auth_header(client_user)
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "GET /admin/v1/products/:id" do
    let!(:product) { create(:product) }
    let(:url) { "/admin/v1/products/#{product.id}" }

    it "retorna os detalhes do produto com status HTTP 200" do
      get url, headers: auth_header(user)
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["data"]["id"].to_i).to eq(product.id)
    end
  end

  describe "POST /admin/v1/products" do
    let(:url) { "/admin/v1/products" }
    let(:image_file) { fixture_file_upload('spec/support/images/product_image.png', 'image/png') }

    context "com parâmetros válidos" do
      let(:valid_params) do
        {
          product: {
            name: "Novo Jogo Incrível",
            description: "Descrição completa do jogo",
            price: 199.90,
            status: :available,
            featured: true,
            image: image_file,
            productable_type: "Game",
            productable_id: game.id,
            category_ids: categories.map(&:id)
          }
        }
      end

      it "cria um novo produto e retorna status HTTP 201 (Created)" do
        expect do
          post url, params: valid_params, headers: auth_header(user)
        end.to change(Product, :count).by(1)

        expect(response).to have_http_status(:created)
      end
    end

    context "com parâmetros inválidos" do
      let(:invalid_params) do
        { product: { name: "", price: -10 } }
      end

      it "não cria o produto e retorna status HTTP 422 (Unprocessable Entity)" do
        expect do
          post url, params: invalid_params, headers: auth_header(user)
        end.not_to change(Product, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /admin/v1/products/:id" do
    let!(:product) { create(:product) }
    let(:url) { "/admin/v1/products/#{product.id}" }

    context "com dados válidos" do
      let(:new_name) { "Nome Atualizado do Produto" }

      it "atualiza o produto e retorna status HTTP 200" do
        patch url, params: { product: { name: new_name } }, headers: auth_header(user)
        expect(response).to have_http_status(:ok)
        expect(product.reload.name).to eq(new_name)
      end
    end
  end

  describe "DELETE /admin/v1/products/:id" do
    let!(:product) { create(:product) }
    let(:url) { "/admin/v1/products/#{product.id}" }

    it "remove o produto e retorna status HTTP 204 (No Content)" do
      expect do
        delete url, headers: auth_header(user)
      end.to change(Product, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end