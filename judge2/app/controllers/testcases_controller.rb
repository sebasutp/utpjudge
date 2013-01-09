class TestcasesController < ApplicationController
    before_filter :req_psetter, :except=>[:index,:show]
    
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

    %{
    def upload
        @testcase = Problem.find(params[:id])
        infile = params[:testcase][:infile]
        outfile = params[:testcase][:outfile]
        ifn = "i" << @testcase.id << infile.original_filename
        ofn = "o" << @testcase.id << outfile.original_filename
        File.open(Rails.root.join('public','correct',ifn), 'w') do |file|
            file.write(infile.read)
        end
        File.open(Rails.root.join('public','correct',ofn), 'w') do |file|
            file.write(outfile.read)
        end
    end
    %}
    
end
