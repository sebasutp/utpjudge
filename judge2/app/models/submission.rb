class Submission < ActiveRecord::Base
  belongs_to :exercise_problem
  attr_accessible :end_date, :init_date, :time, :veredict, :srcfile, :outfile, :tcaseId
  has_attached_file :srcfile, :path => ":rails_root/protected/submissions/s:basename:id.:extension", :url => "s:basename:id.:extension"
  has_attached_file :outfile, :path => ":rails_root/protected/submissions/o:basename:id.:extension", :url => "o:basename:id.:extension"

  validates_attachment_presence :src_file
  validates_attachment_size :src_file, :less_than => 1.megabytes
  validates_attachment_size :out_file, :less_than => 20.megabytes

  def judge()
      #If you change this constants, also change Testcase
      h = Testcase.judgeTypeHash
      tc = Testcase.find(tcaseId)
      jt = h[tc.jtype]
      if jt == :downloadInput
          judgeDownload(tc)
      end
  end

  def judgeDownload(tc)
      ofile1 = tc.outfile.path
      ofile2 = outfile.path
      diff_file = "protected/jdownload.diff"
      veredict = %x{bash protected/djudge.sh #{ofile1} #{ofile2} #{diff_file}}
  end

end
