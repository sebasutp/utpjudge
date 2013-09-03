require 'socket'
require 'thread'
require 'httparty'
require 'json'
require "net/http"
require "uri"

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
    file = File.open("#{fname}","w")
    file.write(str)
    file.close
  end
  
  def judge
    base_name = "runs" + @submission["id"].to_s
    base_path = @folder + "/" + base_name
    srcname = @submission["srcfile_file_name"]

    %x{#{"mkdir #{base_path}"}}
    %x{#{"chmod 777 -R #{base_path}"}}

    write_to_file(base_path + "/" + srcname,@src_code)

    sub_id = @submission["id"]
    tc_id = @submission["testcase_id"]
    
#    if !(@testcases.has_key? tc_id)
      @testcases[tc_id] = tc = SConsumer.get("#{@base_uri}/submissions/#{sub_id}/bot_testcase.json")
      write_to_file "#{base_path}/#{tc_id}.in",tc[0]
      write_to_file "#{base_path}/#{tc_id}.out",tc[1]
#    else
#      tc = @testcases[tc_id]
#     puts tc
#    end    
    
    type = @language["ltype"]
    comp = @language["compilation"]
    exec = @language["execution"]
    timl = @ex_pr["time_limit"]
    progl = @ex_pr["prog_limit"]
    meml = @ex_pr["mem_lim"]
    comp = comp.gsub("SOURCE","Main")
    exec = exec.gsub("SOURCE","Main").gsub("-tTL","-t"+timl.to_s).gsub("ML",meml.to_s).gsub("INFILE","Main.in").gsub("SRUN","safeexec")
    command = "./sjudge.sh '#{srcname}' '#{tc_id}.in' '#{tc_id}.out' #{type} '#{comp}' '#{exec}' #{timl} #{meml} #{progl} #{sub_id}"

    s = %x{#{command}}.split(',')
    ans = sub_id.to_s + "," + s[0].to_s + "," + s[1].to_s
    return ans
    
#   ur = "#{@base_uri}/submissions/#{sub_id}/update_veredict.json"
#   response = SConsumer.get(ur,:query => { :veredict => s, :time => time })
  end

  def process_subm(subm_id)
    s = "#{@base_uri}/submissions/#{subm_id}/judgebot.json"
    response = SConsumer.get(s)
    @submission = response[0]
    @src_code = response[1]
    @language = response[2]
    @ex_pr = response[3]
    judge  
  end

  def run_server()
      port = 3010
      server = TCPServer.new port
      @testcases = {}

      loop {
#         Thread.start(server.accept) do |client|
            client = server.accept
            s = client.gets
            puts "Receiving submission id=#{s}"
            v = process_subm(s.to_i)
            fifo = open("test_fifo", "w+")
            fifo.puts v
            fifo.flush
            client.close
#       end
      }
  end

end


#The actual server launch
server = SJudge.new
server.run_server
