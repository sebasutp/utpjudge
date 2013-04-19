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
  end

  def process_subm(subm_id)
    s = "#{@base_uri}/submissions/#{subm_id}/judgebot.json"
    puts s
    response = SConsumer.get(s)
    #puts response
    @submission = response[0]
    @src_code = response[1]
    puts @src_code
  end

  def run_server()
      port = 3010
      server = TCPServer.new port

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
