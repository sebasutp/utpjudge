class ExcercisesController < ApplicationController
  # GET /excercises
  # GET /excercises.json
  def index
    @excercises = Excercise.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @excercises }
    end
  end

  def getvalid
      @excercises = Excercise.where("from_date <= :cdate and to_date >= :cdate",{:cdate => DateTime.now.to_s(:db)})
  end

  # GET /excercises/1
  # GET /excercises/1.json
  def show
    @excercise = Excercise.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @excercise }
    end
  end

  # GET /excercises/new
  # GET /excercises/new.json
  def new
    @excercise = Excercise.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @excercise }
    end
  end

  # GET /excercises/1/edit
  def edit
    @excercise = Excercise.find(params[:id])
  end

  # POST /excercises
  # POST /excercises.json
  def create
    @excercise = Excercise.new(params[:excercise])

    respond_to do |format|
      if @excercise.save
        format.html { redirect_to @excercise, :notice => 'Excercise was successfully created.' }
        format.json { render :json => @excercise, :status => :created, :location => @excercise }
      else
        format.html { render :action => "new" }
        format.json { render :json => @excercise.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /excercises/1
  # PUT /excercises/1.json
  def update
    @excercise = Excercise.find(params[:id])

    respond_to do |format|
      if @excercise.update_attributes(params[:excercise])
        format.html { redirect_to @excercise, :notice => 'Excercise was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @excercise.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /excercises/1
  # DELETE /excercises/1.json
  def destroy
    @excercise = Excercise.find(params[:id])
    @excercise.destroy

    respond_to do |format|
      format.html { redirect_to excercises_url }
      format.json { head :no_content }
    end
  end
end
