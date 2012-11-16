class ProblemExcercise < ActiveRecord::Base
  attr_accessible :excercise_id, :problem_id, :score, :timelimit
  belongs_to :problem
  belongs_to :excercise
end
