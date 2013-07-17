require 'socket'
require 'httparty'
require 'json'

class SConsumer
  include HTTParty
  format :json
  basic_auth 'user', 'password'
end


class RVeredict

	def initialize()
		@base_uri = 'http://localhost:3000'
    @data = open("test_fifo", "r+")
  end

	def run_rv()

      loop do
          v = @data.gets
					ver = v.split(",")
#					sleep 1
          puts "Receiving veredict=#{v}"
					ur = "#{@base_uri}/submissions/#{ver[0]}/update_veredict.json"
					response = SConsumer.get(ur,:query => { :veredict => ver[1], :time => 0.0 })

      end
  end
end

rv = RVeredict.new
rv.run_rv
