class Language < ActiveRecord::Base
  attr_accessible :compilation, :execution, :ltype, :name

end
