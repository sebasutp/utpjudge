class Problem < ActiveRecord::Base
  attr_accessible :name, :notes, :url
  validates_presence_of :name, :url
  has_many :excercise_problems
  has_many :excercises, :through=>:excercise_problems
  has_many :testcases

end
