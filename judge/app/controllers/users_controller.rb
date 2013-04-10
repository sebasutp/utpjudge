class UsersController < ApplicationController
  before_filter :req_root, :only=>[:index,:destroy,:update,:edit]
  
  # GET /users
  # GET /users.json
  
  def index
    @users = User.paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @groups = Group.all
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @user }
    end
    
    
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create    
    @user = User.newMA(params[:user])    
    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        flash[:class] = "alert alert-success"
        format.html { redirect_to @user, :notice => 'user was successfully created.' }
        format.json { render :json => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  #POST /users/sign_in
  def sign_in
    @user = User.authenticate(params[:user])
    if @user
      session[:user_id] = @user.id
      flash[:class] = "alert alert-success"
      flash[:notice] = "Login successful"
    else
      #flash[:class] = "alert alert-error"
      flash[:notice] = "Login failed. Wrong user name or password"
    end
    
    redirect_to :root
  end
  
  #GET /users/sign_out
  def sign_out
    session[:user_id] = nil
    redirect_to :root
  end

  def add_group
    @user = User.find(params[:id])
    group = Group.find(params[:group])
    if !@user.groups.where(:id => group.id).first
      @user.groups << group
      flash[:class] = "alert alert-success"
      redirect_to @user, :notice => 'Group was successfully added to this user'
    else
      redirect_to @user, :notice => 'This user is already in that group'
    end
  end
  
  def rem_group
    @user = User.find(params[:id])
    group = Group.find(params[:group])
    @user.groups.delete(group)
    flash[:class] = "alert alert-success"
    redirect_to @user, :notice => 'Group was successfully deleted from this user'
  end


  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])
    
    respond_to do |format|
      if @user.updateMA(params[:user])
        flash[:class] = "alert alert-success"
        format.html { redirect_to @user, :notice => 'user was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
end
