class SubmissionsController < ApplicationController
  before_filter :req_psetter, :only=>[:destroy,:update,:edit]
  before_filter :req_gen_user, :except=>[:destroy,:update,:edit]

  # GET /submissions
  # GET /submissions.json
  def index
    u_id = params[:uid]
    if (!u_id || Integer(u_id)!=@current_user.id)
      authorized = @current_user.has_roles(User.roles[:psetter])
      redirect_to :root and return if not authorized
    end
    if u_id
      @submissions = User.find(u_id).submissions.paginate(:page => params[:page], :per_page => 5)
    else
      @submissions = Submission.paginate(:page => params[:page], :per_page => 5)
    end
      
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @submissions }
    end
  end
  

  # GET /submissions/1
  # GET /submissions/1.json
  def show
    @submission = Submission.find(params[:id])
    is_authorized = @current_user.id == @submission.user.id || @current_user.has_roles(User.roles[:psetter])
    redirect_to :root and return if not is_authorized

    if (@submission.veredict == "Judging" || @submission.veredict.length == 0)
      @submission.judge
    end
    @exercise_problem = @submission.exercise_problem
    @srccode = @submission.source

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
        @submission = Submission.newJudgeDownload(@exercise_problem)
        @submission.user = current_user
        @submission.save
        render "jdownload"
      end
  end

  def jdownload
      @submission = Submission.find(params[:id])
      @submission.end_date = DateTime.now
      respond_to do |format|
        if @submission.update_attributes(params[:submission]) && @submission.judge
          #if success redirect to show action
          flash[:class] = "alert alert-success"
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
      problem = @exercise_problem.problem
      testcase = problem.testcases.where(:jtype => @exercise_problem.stype).first
      send_file testcase.infile.path, :type=>"application/text"
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
