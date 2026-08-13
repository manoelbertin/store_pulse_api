# lib/middlewares/static_token_auth.rb
module Middlewares
  class StaticTokenAuth
    def initialize(app)
      @app = app
    end

    def call(env)
      # Exemplo simples de validação do cabeçalho
      request = Rack::Request.new(env)

      # Prossegue com a requisição no pipeline do Rails
      @app.call(env)
    end
  end
end
