class Submission < ActiveRecord::Base
  belongs_to :exercise_problem
  attr_accessible :end_date, :init_date, :time, :veredict, :srcfile, :outfile
  has_attached_file :srcfile, :path => ":rails_root/protected/submissions/s:basename:id.:extension", :url => "s:basename:id.:extension"
  has_attached_file :outfile, :path => ":rails_root/protected/submissions/o:basename:id.:extension", :url => "o:basename:id.:extension"

  validates_attachment_presence :src_file
  validates_attachment_size :src_file, :less_than => 1.megabytes
  validates_attachment_size :out_file, :less_than => 20.megabytes

  def judge()
      j = JudgeDownload.new
      return "hello" << j.mundo()
  end

end
