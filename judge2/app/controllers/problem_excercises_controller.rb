class ProblemExcercisesController < ApplicationController
  # GET /problem_excercises
  # GET /problem_excercises.json
  def index
    @problem_excercises = ProblemExcercise.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @problem_excercises }
    end
  end

  # GET /problem_excercises/1
  # GET /problem_excercises/1.json
  def show
    @problem_excercise = ProblemExcercise.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @problem_excercise }
    end
  end

  # GET /problem_excercises/new
  # GET /problem_excercises/new.json
  def new
    @problem_excercise = ProblemExcercise.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @problem_excercise }
    end
  end

  # GET /problem_excercises/1/edit
  def edit
    @problem_excercise = ProblemExcercise.find(params[:id])
  end

  # POST /problem_excercises
  # POST /problem_excercises.json
  def create
    @problem_excercise = ProblemExcercise.new(params[:problem_excercise])

    respond_to do |format|
      if @problem_excercise.save
        format.html { redirect_to @problem_excercise, :notice => 'Problem excercise was successfully created.' }
        format.json { render :json => @problem_excercise, :status => :created, :location => @problem_excercise }
      else
        format.html { render :action => "new" }
        format.json { render :json => @problem_excercise.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /problem_excercises/1
  # PUT /problem_excercises/1.json
  def update
    @problem_excercise = ProblemExcercise.find(params[:id])

    respond_to do |format|
      if @problem_excercise.update_attributes(params[:problem_excercise])
        format.html { redirect_to @problem_excercise, :notice => 'Problem excercise was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @problem_excercise.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /problem_excercises/1
  # DELETE /problem_excercises/1.json
  def destroy
    @problem_excercise = ProblemExcercise.find(params[:id])
    @problem_excercise.destroy

    respond_to do |format|
      format.html { redirect_to problem_excercises_url }
      format.json { head :no_content }
    end
  end
end
