class ExerciseProblem < ActiveRecord::Base
  belongs_to :exercise
  belongs_to :problem
  attr_accessible :mem_lim, :problem_number, :prog_limit, :score, :stype, :time_limit

  def solved?(user)
    return self.submissions.where(:user_id => user.id, :veredict => "YES").count > 0
  end
end
