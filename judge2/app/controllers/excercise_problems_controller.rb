class ExcerciseProblemsController < ApplicationController

    def create
        @excercise = Excercise.find(params[:excercise_id])
        @excercise_problem = @excercise.excercise_problems.create(params[:excercise_problem])
        redirect_to excercise_path(@excercise)
    end

end
