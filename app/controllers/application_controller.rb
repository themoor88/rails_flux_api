class ApplicationController < ActionController::API
  # This helps with rendering views from outside controllers
  include AbstractController::Translation

  before_action :authenticate_user_from_token!
  respond_to :json

  # User authentication
  def authenticate_user_from_token
    auth_token = request.headers['Authorization']

    if auth_token
      authenticate_with_auth_token auth_token
    else
      authentication_error
    end
  end

  private
  def authenticate_with_auth_token auth_token
    unless auth_token.include?(':')
      authentication_error
      return
    end

    user_id = auth_token.split(':').first
    user = User.where(id: user_id).first

    if user && Devise.secure_compare(user.access_token, auth_token)
      sign_in user, store: false
    else
      authentication_error
    end
  end

  # Authentication failure renders a 401 error
  def authentication_error
    # If the user's token is invalid or not in the right format we will timeout
    render json: {error: t('unauthorized')}, status: 401
  end
end
