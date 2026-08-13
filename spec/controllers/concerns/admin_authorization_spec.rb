require 'rails_helper'

RSpec.describe AdminAuthorization, type: :controller do
  controller(ApplicationController) do
    include AdminAuthorization
    before_action :authorize_admin_from_header!

    def index
      render json: { ok: true }
    end
  end

  let(:admin) { create(:user, profile: :admin) }
  let(:client) { create(:user, profile: :client) }

  it 'permite acesso quando o uid do header pertence a um admin' do
    request.headers['uid'] = admin.uid
    get :index
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)['ok']).to eq(true)
  end

  it 'bloqueia acesso quando o usuário não é admin' do
    request.headers['uid'] = client.uid
    get :index
    expect(response).to have_http_status(:forbidden)
  end
end
