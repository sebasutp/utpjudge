class Language < ActiveRecord::Base
  attr_accessible :compilation, :execution, :ltype, :name
  has_many :submissions
  #ltype: is compiled(1) or interpreted(2)?
  #name: Human friendly name
  #execution and compilation: lines to execute and compile the code with uppercase keywords to be
  # replaced by the actual filenames

end
