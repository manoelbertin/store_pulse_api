class CreateEcommerceSchema < ActiveRecord::Migration[8.0]
  def change
    # 1. Categorias
    create_table :categories do |t|
      t.string :name, null: false
      t.timestamps
    end

    # 2. Usuários (Necessária antes de Orders e WishItems)
    create_table :users do |t|
      t.string :provider, default: "email", null: false
      t.string :uid, default: "", null: false
      t.string :encrypted_password, default: "", null: false
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.boolean :allow_password_change, default: false
      t.datetime :remember_created_at
      t.string :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string :unconfirmed_email
      t.string :name, null: false
      t.string :email, null: false
      t.integer :profile, default: 1, null: false
      t.json :tokens

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, [:uid, :provider], unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token, unique: true

    # 3. Requisitos de Sistema
    create_table :system_requirements do |t|
      t.string :name, null: false
      t.string :operational_system, null: false
      t.string :storage, null: false
      t.string :processor, null: false
      t.string :memory, null: false
      t.string :video_board, null: false
      t.timestamps
    end

    # 4. Cupons de Desconto
    create_table :coupons do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.integer :status, default: 0, null: false
      t.decimal :discount_value, precision: 5, scale: 2, null: false
      t.datetime :due_date, null: false
      t.timestamps
    end

    # 5. Jogos
    create_table :games do |t|
      t.integer :mode, null: false
      t.datetime :release_date, null: false
      t.string :developer, null: false
      t.references :system_requirement, null: false, foreign_key: true
      t.timestamps
    end

    # 6. Produtos (Polimórfico)
    create_table :products do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.decimal :price, precision: 10, scale: 2, null: false
      t.references :productable, polymorphic: true, null: false
      t.integer :status, default: 0, null: false
      t.boolean :featured, default: false
      t.timestamps
    end

    # 7. Categorias do Produto (Join Table)
    create_table :product_categories do |t|
      t.references :product, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.timestamps
    end

    # 8. Pedidos
    create_table :orders do |t|
      t.integer :status, default: 0, null: false
      t.decimal :subtotal, precision: 10, scale: 2, null: false
      t.decimal :total_amount, precision: 10, scale: 2, null: false
      t.integer :payment_type, null: false
      t.integer :installments, default: 1
      t.references :user, null: false, foreign_key: true
      t.references :coupon, foreign_key: true
      t.timestamps
    end

    # 9. Itens do Pedido
    create_table :line_items do |t|
      t.integer :quantity, null: false
      t.decimal :payed_price, precision: 10, scale: 2, null: false
      t.integer :status, default: 0, null: false
      t.references :order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.timestamps
    end

    # 10. Licenças dos Jogos
    create_table :licenses do |t|
      t.string :key, null: false
      t.integer :platform, null: false
      t.integer :status, default: 0, null: false
      t.references :game, null: false, foreign_key: true
      t.references :line_item, foreign_key: true
      t.timestamps
    end

    # 11. Lista de Desejos
    create_table :wish_items do |t|
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.timestamps
    end
  end
end
