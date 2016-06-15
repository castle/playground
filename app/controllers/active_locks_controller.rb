class ActiveLocksController < ApplicationController
  before_filter :lock_resolved

  def lock_resolved
    if current_user
      authentication = Authentication.find_by(
        castle_authentication_id: session[:authentication_id],
        user_id: current_user.id
      )
      redirect_to account_path unless authentication && authentication.status.lock?
    end
  end
end


