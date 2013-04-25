require 'socket'
require 'thread'
require 'httparty'
require 'json'

class SConsumer
  include HTTParty
  format :json
  basic_auth 'user', 'password'
end

class SJudge

  def initialize()
    @base_uri = 'http://localhost:3000'
    @folder = 'files'
  end
  
  def write_to_file(fname,str)
    file = File.open("#{@folder}/#{fname}","w")
    file.write(str)
    file.close
  end
  
  def judge
    srcname = @submission["srcfile_file_name"]
    folder = "tmp/"
    write_to_file(srcname,@src_code)
    sub_id = @submission["id"]
    tc_id = @submission["testcase_id"]
    if !(@testcases.has_key? tc_id)
      @testcases[tc_id] = tc = SConsumer.get("#{@base_uri}/submissions/#{sub_id}/bot_testcase.json")
      write_to_file "#{tc_id}.in",tc[0]
      write_to_file "#{tc_id}.out",tc[1]
    else
      tc = @testcases[tc_id]
    end    
    puts [@src_code,tc[0],tc[1]]
    type = @language["ltype"]
    comp = @language["compilation"]
    exec = @language["execution"]
    timl = @ex_pr["time_limit"]
    progl = @ex_pr["prog_limit"]
    meml = @ex_pr["mem_lim"]
    comp = comp.gsub("SOURCE","Main")
    exec = exec.gsub("SOURCE","Main").gsub("-tTL","-t"+timl.to_s).gsub("ML",meml.to_s).gsub("INFILE","Main.IN").gsub("SRUN","./safeexec")
    command = "./sjudge.sh '#{srcname}' '#{tc_id}.in' '#{tc_id}.out' #{type} '#{comp}' '#{exec}' #{timl} #{meml} #{progl}"
    puts command
    s = %x{#{command}}
    puts s
  end

  def process_subm(subm_id)
    s = "#{@base_uri}/submissions/#{subm_id}/judgebot.json"
    puts s
    response = SConsumer.get(s)
    #puts response
    @submission = response[0]
    @src_code = response[1]
    @language = response[2]
    @ex_pr = response[3]
    puts response
    judge    
  end

  def run_server()
      port = 3010
      server = TCPServer.new port
      @testcases = {}

      loop do
          client = server.accept
          s = client.gets
          puts "Receiving submission id=#{s}"
          process_subm(s.to_i)
          client.close
      end
  end

end


#The actual server launch
server = SJudge.new
server.run_server
