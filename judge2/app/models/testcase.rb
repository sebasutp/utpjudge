
class Testcase < ActiveRecord::Base
  belongs_to :problem
  attr_accessible :jtype,:infile,:outfile
  has_attached_file :infile, :path => ":rails_root/protected/correct/:basename:id.:extension"
  has_attached_file :outfile, :path => ":rails_root/protected/correct/:basename:id.:extension"
  
end
