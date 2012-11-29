class ExcerciseProblem < ActiveRecord::Base
  belongs_to :excercise
  belongs_to :problem
  attr_accessible :problem_number, :score, :time_limit
end
