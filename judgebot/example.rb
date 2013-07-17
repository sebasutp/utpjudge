require 'thread' 	#for backwards comparability with 
require 'socket'
				#1.8
#@lock = Mutex.new 	#our lock
#s = %x{#{"mkfifo test_fifo"}} 

t1 = Thread.new {
#	loop do 
#		@lock.synchronize {
			result = { :ver => "YES", :tim => "0.01" }
			veredict = "49 YES"
			input = open("test_fifo", "w+")
			input.puts result
			input.flush
#		}
#	end
}

spy = Thread.new {
#  loop do
#    @lock.synchronize { 
			veredict = "50 TIMELIMIT"
			input = open("test_fifo", "w+")
			input.puts veredict
			input.flush
#    }
#  end
}
t1.join
spy.join
#sleep 1
#puts "x: #{x}\ny: #{y}\n Dif: #{veredict}"
