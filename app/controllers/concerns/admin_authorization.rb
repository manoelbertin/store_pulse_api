module AdminAuthorization
  extend ActiveSupport::Concern

  included do
    private

    def authorize_admin_from_header!
      uid = request.headers['uid'] || request.headers['HTTP_UID'] || request.headers['Uid']
      user = User.find_by(uid: uid) || User.find_by(email: uid)

      return if user&.admin?

      render json: { error: 'Forbidden' }, status: :forbidden
    end
  end
end
