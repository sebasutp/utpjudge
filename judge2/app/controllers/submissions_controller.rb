class SubmissionsController < ApplicationController
  before_filter :req_gen_user, :except=>[:index,:show]
  before_filter :req_psetter, :except=>[:new,:create]

  # GET /submissions
  # GET /submissions.json
  def index
    @submissions = Submission.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @submissions }
    end
  end

  # GET /submissions/1
  # GET /submissions/1.json
  def show
    @submission = Submission.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @submission }
    end
  end

  # GET /submissions/new
  def new
      @exercise_problem = ExerciseProblem.find(params[:exercise_problem])
      @jtype = Testcase.judgeTypeHash[@exercise_problem.stype]
      if @jtype==:downloadInput
          @submission = Submission.new
          @submission.init_date = DateTime.now
          @submission.exercise_problem = @exercise_problem
          @submission.veredict = 'TL'
          @submission.save
          render "jdownload"
      end
  end

  def jdownload
      @submission = Submission.find(params[:id])
      @submission.end_date = DateTime.now
      respond_to do |format|
        if @submission.update_attributes(params[:submission])
            #if success redirect to show action
            format.html { redirect_to @submission, notice: 'Your submission was successfully sent.' }
            format.json { head :no_content }
        else
            format.html { render action: "new" }
            format.json { render json: @submission.errors, status: :unprocessable_entity }
        end
      end
  end

  #GET /submissions/downloadInput?exercise_problem=id
  def downloadInput
      @exercise_problem = ExerciseProblem.find(params[:exercise_problem])      
  end

  # GET /submissions/1/edit
  def edit
    @submission = Submission.find(params[:id])
  end

  # POST /submissions
  # POST /submissions.json
  def create
    @submission = Submission.new(params[:submission])

    respond_to do |format|
      if @submission.save
        format.html { redirect_to @submission, notice: 'Submission was successfully created.' }
        format.json { render json: @submission, status: :created, location: @submission }
      else
        format.html { render action: "new" }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /submissions/1
  # PUT /submissions/1.json
  def update
    @submission = Submission.find(params[:id])

    respond_to do |format|
      if @submission.update_attributes(params[:submission])
        format.html { redirect_to @submission, notice: 'Submission was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /submissions/1
  # DELETE /submissions/1.json
  def destroy
    @submission = Submission.find(params[:id])
    @submission.destroy

    respond_to do |format|
      format.html { redirect_to submissions_url }
      format.json { head :no_content }
    end
  end
end
