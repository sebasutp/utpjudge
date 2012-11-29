class Problem include MongoMapper::Document
  #attr_accessible :name, :notes, :url
  key :name, String
  key :notes, String
  key :url, String
  validates_presence_of :name, :url
  has_many :excercise_problems
  has_many :excercises, :through=>:excercise_problems

end
