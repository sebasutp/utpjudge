class Exercise < ActiveRecord::Base
  attr_accessible :from_date, :name, :to_date
  validates_presence_of :name
  validate :date_range
  has_many :exercise_problems, :dependent => :destroy
  has_many :problems, :through=>:exercise_problems

  def date_range
    if (from_date >= to_date)
	  errors.add(:to_date, "Final date cannot be less that start date")
    end
  end
end
