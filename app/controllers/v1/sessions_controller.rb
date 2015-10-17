module v1
  class SessionsController < ApplicationController
    skip_before_action :authenticate_user_from_token!

    # POST /v1/login
  end
end