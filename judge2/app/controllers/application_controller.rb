class ApplicationController < ActionController::Base
  protect_from_forgery

  def unauthorized_user
      redirect_to root_path
      return false
  end

  def req_root
      req_role(1)
  end

  def req_psetter
      req_role(2)
  end

  def req_gen_user
      req_role(3)
  end

  def req_role(rid)
      u = current_user
      return unauthorized_user unless u
      rids = u.role_ids
      return unauthorized_user unless rids.include? rid
  end

end
