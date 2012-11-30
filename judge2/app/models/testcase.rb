class Testcase < ActiveRecord::Base
  belongs_to :problem
  attr_accessible :infile, :jtype, :outfile
end
