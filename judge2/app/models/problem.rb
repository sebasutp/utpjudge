class Problem < ActiveRecord::Base
  attr_accessible :name, :notes, :url
  validates_presence_of :name, :url
  has_many :problem_excercises
  has_many :excercises, :through=>:problem_excercises

end
