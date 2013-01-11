class ExerciseProblem < ActiveRecord::Base
  belongs_to :exercise
  belongs_to :problem
  has_many :submissions
  attr_accessible :problem_number, :score, :time_limit, :problem_id, :mem_lim, :stype, :prog_limit

  def solved?(user)
    return self.submissions.where(:user_id => user.id, :veredict => "YES").count > 0
  end
end
