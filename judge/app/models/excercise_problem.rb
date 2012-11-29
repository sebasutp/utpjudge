class ExcerciseProblem include MongoMapper::Document 
  belongs_to :excercise
  belongs_to :problem
  #attr_accessible :problem_number, :score, :time_limit, :problem_id
  key :problem_number,Integer
  key :score, Integer
  key :time_limit, Integer
  key :problem_id, ObjectId
  key :excercise_id, ObjectId
end
