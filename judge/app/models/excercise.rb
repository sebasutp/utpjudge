class Excercise < ActiveRecord::Base
  attr_accessible :from, :name, :to, :url

  validates :name, :presence => true
  validates :from, :presence => true
  validates :to, :presence => true
  validate :date_range

  def date_range
    if (from >= to)
	errors.add(:to, "Final date cannot be less that start date")
    end
  end
end
