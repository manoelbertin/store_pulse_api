require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

# Carrega automaticamente todos os arquivos dentro de spec/support/ (helpers, shared examples, etc)
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

# Configuração do Shoulda Matchers
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.configure do |config|
  # Apelida 'it_has_behavior_of' para funcionar exatamente como 'it_should_behave_like'
  config.alias_it_should_behave_like_to :it_has_behavior_of

  # Fixtures
  config.fixture_paths = ["#{::Rails.root}/spec/fixtures"]

  # We're using DatabaseCleaner to manage the DB state, so disable
  # RSpec's transactional fixtures to avoid conflicts.
  config.use_transactional_fixtures = false

  # FactoryBot syntax
  config.include FactoryBot::Syntax::Methods

  # Infer spec types from file location and filter Rails backtraces
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  # DatabaseCleaner configuration
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
