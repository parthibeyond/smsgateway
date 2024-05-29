class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  def authenticate
    authenticate_with_http_basic do |username, auth_id| 
      account = Account.find_by(username: username)
      @current_account = account if account&.auth_id.eql?(auth_id)
    end
    head 403 unless @current_account
  end
end
