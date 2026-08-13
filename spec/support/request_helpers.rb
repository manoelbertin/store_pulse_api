module RequestHelpers
  def auth_header(user)
    user.create_new_auth_token
  end
end

RSpec.configure do |config|
  config.include RequestHelpers, type: :request
end
