class ExerciseProblemsController < ApplicationController

    def create
        @exercise = Exercise.find(params[:exercise_id])
        @exercise_problem = @exercise.exercise_problems.create(params[:exercise_problem])
        redirect_to exercise_path(@exercise)
    end

    def destroy
        @exercise = exercise.find(params[:exercise_id])
        @exercise_problem = @exercise.exercise_problems.find(params[:id])
        @exercise_problem.destroy
        redirect_to exercise_path(@exercise)
    end

end
