class User < ActiveRecord::Base
  include Clearance::User

  def lock!
    unless lock
      update_attribute(:lock, true)
      forgot_password!
      ClearanceMailer.change_password(self).deliver_later
    end
  end

  def unlock!
    update_attribute(:lock, false)
  end
end
