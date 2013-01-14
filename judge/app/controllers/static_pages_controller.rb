class StaticPagesController < ApplicationController
  before_filter :req_psetter, :except=>[:home]
  
  
  def home
    if session[:user_id]
      @user = User.find(session[:user_id])
    end
  end
  
  def admin
    if session[:user_id]
      @user = User.find(session[:user_id])
    end
  end

end
