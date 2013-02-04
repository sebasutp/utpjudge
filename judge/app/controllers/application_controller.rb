class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_user
  
  def set_user
    @current_user = current_user
  end
  
  def current_user
    uid = session[:user_id]
    return nil if not uid
    return User.find(uid)
  end
  
  def unauthorized_user(should_redirect=true)
      redirect_to(root_path, :notice => "You need to log in to perform that action") if should_redirect
      return false
  end

  def req_root
      req_role(User.roles[:root])
  end

  def req_psetter
      req_role(User.roles[:psetter])
  end

  def req_gen_user
      req_role(User.roles[:g_user])
  end

  def req_role(rid)
      u = current_user
      return unauthorized_user unless u
      return unauthorized_user unless u.has_roles(rid)
  end
end
