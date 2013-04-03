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
  
end
