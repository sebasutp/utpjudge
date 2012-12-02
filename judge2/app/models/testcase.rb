
class Testcase < ActiveRecord::Base
  belongs_to :problem
  attr_accessible :jtype,:infile,:outfile
  has_attached_file :infile, :path => ":rails_root/protected/correct/:basename:id.:extension", :url => ":basename:id.:extension"
  has_attached_file :outfile, :path => ":rails_root/protected/correct/:basename:id.:extension", :url => ":basename:id.:extension"
  validates_attachment_presence :infile
  validates_attachment_size :infile, :less_than => 20.megabytes
  validates_attachment_presence :outfile
  validates_attachment_size :outfile, :less_than => 20.megabytes
  
end
