$semaphore = Mutex.new
veredict = 0

a = Thread.new {
	loop do	     
  	@semaphore.synchronize {
			veredict += 1
			sleep 0.1
  	}
	end
}

b = Thread.new {
	loop do
	  @semaphore.synchronize {
			veredict += 10
  	}
	end
}

#a.join
#b.join
sleep 1
puts "veredict: #{veredict}"
