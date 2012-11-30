class TestcasesController < ApplicationController
    
    def create
        @problem = Problem.find(params[:problem_id])
        @testcase = @problem.testcases.create(params[:testcase])
        redirect_to problem_path(@problem)
    end

    def destroy
        @problem = Problem.find(params[:problem_id])
        @testcase = @problem.testcases.find(params[:id])
        @testcase.destroy
        redirect_to problem_path(@problem)
    end

end
