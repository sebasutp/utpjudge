require 'test_helper'

class ExerciseProblemTest < ActiveSupport::TestCase
  test "right path" do
    ep = ExerciseProblem.new
    ep.problem = problems(:ptroilo)
    ep.exercise = exercises(:test_exercise)
    ep.time_limit = 120
    assert ep.save
    a = ExerciseProblem.where(:time_limit=>120)
    assert a.count==1
  end
  
end
