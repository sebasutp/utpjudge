class StaticPagesController < ApplicationController
  before_filter :req_psetter, :except=>[:home]
  
  def home
    @user = current_user
  end
  
  def admin
    @user = current_user
  end
  
end
