class Submission < ActiveRecord::Base
  belongs_to :exercise_problem
  belongs_to :user
  belongs_to :testcase
  belongs_to :language

  attr_accessible :end_date, :init_date, :time, :srcfile, :outfile, :infile
  #attr_accessor :language_id
  has_attached_file :srcfile, :path => ":rails_root/protected/submissions/s:basename:id.:extension", :url => "s:basename:id.:extension"
  has_attached_file :outfile, :path => ":rails_root/protected/submissions/o:basename:id.:extension", :url => "o:basename:id.:extension"

  #validates_attachment_presence :src_file
  validates_attachment_size :srcfile, :less_than => 1.megabytes
  validates_attachment_size :outfile, :less_than => 20.megabytes

  def self.newJudgeDownload(exercise_problem)
    s = Submission.new
    s.init_date = DateTime.now
    s.exercise_problem = exercise_problem
    s.veredict = 'TL'
    testcases = exercise_problem.problem.testcases.where(:jtype => exercise_problem.stype)
    s.testcase = testcases.first
    return s
  end

	## Code to judge uploadSource
  def self.newJudgeSource(exercise_problem)
    s = Submission.new
    s.init_date = DateTime.now
    s.exercise_problem = exercise_problem
    s.veredict = 'Judging'
    testcases = exercise_problem.problem.testcases.where(:jtype => exercise_problem.stype)
    s.testcase = testcases.first
    return s
  end

  def veredict=(v)
    if v
      write_attribute(:veredict, v.delete("\n"))
    end
  end

  def veredict
    read_attribute(:veredict)
  end

  def judge()
      #If you change this constants, also change Testcase
      self.veredict = "Judging"
      h = Testcase.judgeTypeHash
      tc = self.testcase
      jt = h[tc.jtype]
      if jt == :downloadInput
        judgeDownload(tc)
      else
        judgeUpload(tc)
      end
      save
  end

  def file_exist? (fpath)
      return fpath && FileTest.exists?(fpath)
  end

  def judgeDownload(tc)
      ofile1 = tc.outfile.path
      ofile2 = outfile.path
      self.time = self.end_date - self.init_date
      if self.time > self.exercise_problem.time_limit
      	self.veredict = 'TL'
      else
			if file_exist? ofile2
				s = %x{bash djudge.sh #{ofile1} #{ofile2}}
				self.veredict = s.split.last 
			end
      end
  end

	def judgeUpload(tc)
    lan = self.language
    exp = self.exercise_problem
    timl = exp.prog_limit
    meml = exp.mem_lim
		ofile = tc.outfile.path
		ifile = tc.infile.path
		sfile = srcfile.path
		
		comp = lan.compilation.gsub("SOURCE","Main")
		exec = lan.execution.gsub("SOURCE","Main").gsub("-tTL","-t"+timl.to_s).gsub("ML",meml.to_s).gsub("INFILE","Main.IN")
		#tl = timl
		#ml = meml
		type = lan.ltype
    self.veredict = "Judging"

		if file_exist? sfile
		  #Tell server that a new submission arrived
      #s = %x{sudo -u utpjudjail /home/insilico/utpjudge/judge/sjudge.sh #{sfile} #{ifile} #{ofile} #{type} '#{comp}' '#{exec}' #{timl} #{meml}}
			#self.veredict = s
      #save      
		end
	end

  def source
      srcf = srcfile.path
      if file_exist? srcf
          s = File.open(srcf).read
          return "The source code has non UTF8 characters" if not s.is_utf8?
          return s
      end
      return "No source code"
  end
  
  def get_test_cases
    tc = self.testcase
    in_file = tc.infile.path
    out_file = tc.outfile.path
    if (file_exist? in_file) && (file_exist? out_file)
      return [File.open(in_file).read, File.open(out_file).read]
    else
      return "Error: Could not find output and input files"
    end
  end

end
