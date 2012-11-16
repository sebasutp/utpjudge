class Excercise < ActiveRecord::Base
  attr_accessible :from_date, :name, :to_date
  validates_presence_of :name
  validate :date_range
  has_many :problem_excercises
  has_many :problems, :through=>:problem_excercises

  def date_range
    if (from_date >= to_date)
	  errors.add(:to_date, "Final date cannot be less that start date")
    end
  end
end
