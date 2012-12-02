class Problem < ActiveRecord::Base
  attr_accessible :name, :notes, :pdescription
  has_attached_file :pdescription, :path => ":rails_root/protected/problems/:basename:id.:extension", :url => ":basename:id.:extension"

  validates_presence_of :name
  validates_attachment_presence :pdescription
  validates_attachment_size :pdescription, :less_than => 2.megabytes

  has_many :excercise_problems
  has_many :excercises, :through=>:excercise_problems
  has_many :testcases
end
