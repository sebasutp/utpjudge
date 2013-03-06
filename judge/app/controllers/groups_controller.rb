class GroupsController < ApplicationController
  before_filter :req_psetter, :except=>:index
  before_filter :req_root, :only=>:index
  before_filter :match_user, :except => [:index, :new, :create]

  def match_user
    group = Group.find(params[:id])
    auth = @current_user && @current_user.id==group.owner
    return unauthorized_user unless auth
  end
  
  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @groups }
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @group = Group.find(params[:id])
    @users = User.all
    @exercises = Exercise.all

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @group }
    end
  end

  # GET /groups/new
  # GET /groups/new.json
  def new
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @group }
    end
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
    return unless match_user(@group)
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(params[:group])
    @group.owner = @current_user.id

    respond_to do |format|
      if @group.save
        flash[:class] = "alert alert-success"
        @group.users << @current_user
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render json: @group, status: :created, location: @group }
      else
        format.html { render action: "new" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.json
  def update
    @group = Group.find(params[:id])
    return unless match_user(@group)

    respond_to do |format|
      if @group.update_attributes(params[:group])
        flash[:class] = "alert alert-success"
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def add_user
    @group = Group.find(params[:id])
    user = User.find(params[:user])
    if !@group.users.where(:id => user.id).first
      @group.users << user
      flash[:class] = "alert alert-success"
      redirect_to @group, :notice => 'User was successfully added to this group'
    else
      redirect_to @user, :notice => 'That user is already in this group'
    end 
  end
  
  def rem_user
  	@group = Group.find(params[:id])
    user = User.find(params[:user])
    @group.users.delete(user)
    flash[:class] = "alert alert-success"
    redirect_to @group, :notice => 'User was successfully deleted from this group'
  end
  
  def add_exer
    @group = Group.find(params[:id])
    exercise = Exercise.find(params[:exercise])
    @group.exercises << exercise
    flash[:class] = "alert alert-success"
    redirect_to @group, :notice => 'Exercise was successfully added to this group'
  end
  
  def rem_exer
  	@group = Group.find(params[:id])
    exercise = Exercise.find(params[:exercise])
    @group.exercises.delete(exercise)
    flash[:class] = "alert alert-success"
    redirect_to @group, :notice => 'Exercise was successfully deleted from this group'
  end
  
  
  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group = Group.find(params[:id])
    #return unless match_user(@group)
    @group.destroy

    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json { head :no_content }
    end
  end
  
end
