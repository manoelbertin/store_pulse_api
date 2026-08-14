require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Associações' do
    it { should have_many(:orders).dependent(:restrict_with_error) }
    it { should have_many(:wish_items).dependent(:destroy) }
    it { should have_many(:wishlisted_products).through(:wish_items).source(:product) }
  end

  describe 'Validações' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:profile) }

    subject { create(:user) }
    it 'valida unicidade do email sem diferenciar maiúsculas/minúsculas' do
      create(:user, email: 'tim.murray@runte.example')
      user = build(:user, email: 'TIM.MURRAY@RUNTE.EXAMPLE')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('já está em uso')
    end
  end

  describe 'Enums' do
    it { should define_enum_for(:profile).with_values(admin: 0, client: 1) }
  end

  describe 'Callbacks e Métodos' do
    it 'converte o e-mail para minúsculas antes de salvar' do
      user = create(:user, email: 'USUARIO@TESTE.COM')
      expect(user.email).to eq('usuario@teste.com')
    end

    it 'retorna apenas o primeiro nome com o método #first_name' do
      user = build(:user, name: 'Manoel Bertin Silva')
      expect(user.first_name).to eq('Manoel')
    end
  end
end
