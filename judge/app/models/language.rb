class Language < ActiveRecord::Base
  attr_accessible :compilation, :execution, :ltype, :name
	has_many :submissions
end
