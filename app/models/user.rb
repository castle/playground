class User < ActiveRecord::Base
  include Clearance::User

  def lock!
    if !lock
      update_attribute(:lock, true)
      forgot_password!
      ClearanceMailer.change_password(self).deliver_later
    end
  end

  def unlock!
    update_attribute(:lock, false)
  end

  def send_notification_email(castle_security_context)
    risk_reasons = castle_security_context.risk_reasons
    approve_url = castle_security_context.approve_url
    deny_url  = castle_security_context.deny_url
    
    UserMailer.suspicious_activity(self, risk_reasons, approve_url, deny_url).deliver_later
  end
end
