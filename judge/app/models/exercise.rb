class Exercise < ActiveRecord::Base
  attr_accessible :from_date, :name, :to_date

  validates_presence_of :name, :from_date, :to_date
  validate :date_range
  has_many :exercise_problems, :dependent => :destroy
  has_many :problems, :through=>:exercise_problems

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
    else
      return elapsed
    end
  end

  def current?
    #returns weather the exercise can be done or not given the current date
    #and the from->to dates
    return (Time.parse(to_date.to_s(:db)) >= Time.now) && (Time.parse(from_date.to_s(:db)) < Time.now)
  end

end
