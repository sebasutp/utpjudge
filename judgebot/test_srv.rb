require 'socket'

cont = 118
n = 1
n.times do |x|
	s = TCPSocket.new 'localhost', 3010
	r = Random.new
#	t = r.rand(0...104)
	t = cont
	puts "Write a submission id: " + t.to_s
	s.puts t
	cont += 1
end

