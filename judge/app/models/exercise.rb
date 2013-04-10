class Exercise < ActiveRecord::Base
  attr_accessible :from_date, :name, :to_date

  validates_presence_of :name, :from_date, :to_date
  validate :date_range
  has_many :exercise_problems, :dependent => :destroy
  has_many :problems, :through=>:exercise_problems
  has_many :submissions, :through=>:exercise_problems
  
  has_and_belongs_to_many :users
  has_and_belongs_to_many :groups

  def date_range
    if (from_date and to_date)
      if (from_date >= to_date)
        errors.add(:to_date, "Final date cannot be less that start date")
      end
    end
  end
  
  def elapsed_time
    elapsed = (Time.now - (Time.parse(from_date.to_s(:db)))/60.0).to_i
    if elapsed < 0
      return 0
    end
    return elapsed
  end
  
  def time_to_end
    elapsed = ((Time.parse(to_date.to_s(:db)) - Time.now)/60.0).to_i
    if elapsed < 0
      return 0
    end
    return elapsed
  end
  
  def add_user(some_user)
    users << some_user unless users.include?(some_user)
  end

  def current?
    return (Time.parse(to_date.to_s(:db)) >= Time.now) && (Time.parse(from_date.to_s(:db)) < Time.now)
  end
  
  def finished?
    return Time.now > Time.parse(to_date.to_s(:db)) 
  end
  
  def time_to_start
    to_start = ((Time.parse(from_date.to_s(:db)) - Time.now)/60.0).to_i
    if to_start < 0
      return 0
    end
    return to_start
  end
    
  def users_sorted_by_score
    users.all.sort_by { |user| [number_of_solved_problems(user), -total_penalty(user)] }.reverse
  end
  
  def number_of_solved_problems(user)
    submissions.where(:user_id => user, :veredict => "YES").collect(&:exercise_problem).uniq.size
  end
  
  def first_accepted_submission(user, ex_problem)
    submissions.where(:user_id => user, :veredict => "YES" ,:exercise_problem_id => ex_problem).order("end_date ASC").first
  end
  
  def time_of_first_solution(user, ex_problem)
    submission = first_accepted_submission(user, ex_problem)
    submission.blank? ? nil : ((submission.end_date - from_date) / 60).round
  end
  
  def problem_solved?(user, ex_problem)
    first_accepted_submission(user, ex_problem).present?
  end
  
  def number_of_tries(user,ex_problem)
    submissions.where(:user_id => user, :exercise_problem_id => ex_problem).count
  end
  
  def wrong_tries_before_solution(user, ex_problem)
    return -1 if number_of_tries(user,ex_problem) < 1 
    solution = first_accepted_submission(user, ex_problem)
    date = solution.blank? ? to_date + 1 : solution.end_date
    submissions.where(:user_id => user, :exercise_problem_id => ex_problem).where("end_date < ?", date).count
  end
  
  def penalty_for_single_problem(user, ex_problem)
    if problem_solved?(user, ex_problem)
      time_of_first_solution(user, ex_problem) + wrong_tries_before_solution(user, ex_problem) * 20
    else
      0
    end
  end
  
  def total_penalty(user)
    exercise_problems.inject(0) { |sum, problem| sum + penalty_for_single_problem(user, problem) }
  end
  
  def letter_for_problem(ex_problem)
    exercise_problems.each_with_index do |p, i|
      return ('A'.ord + i).chr if p == problem
    end
    return '~'
  end
  
  def within_contest_time_lapse?(some_time)
    start_date <= some_time and some_time <= end_date
  end
  
end
