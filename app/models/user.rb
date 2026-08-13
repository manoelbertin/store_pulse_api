class User < ApplicationRecord
  # Módulos padrão do Devise
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Módulo do Devise Token Auth para geração de tokens por header
  include DeviseTokenAuth::Concerns::User

  # Enum para perfil de acesso (admin: 0, client: 1)
  attribute :profile, :integer, default: 1
  enum :profile, { admin: 0, client: 1 }

  # Relacionamentos do E-commerce
  has_many :orders, dependent: :restrict_with_error
  has_many :wish_items, dependent: :destroy
  has_many :wishlisted_products, through: :wish_items, source: :product

  # Validações
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :profile, presence: true

  # Callbacks para padronização de dados
  before_save :downcase_email

  # Métodos auxiliares
  def first_name
    name.strip.split.first
  end

  private

  def downcase_email
    self.email = email.downcase.strip if email.present?
  end
end
