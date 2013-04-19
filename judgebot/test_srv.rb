require 'socket'

s = TCPSocket.new 'localhost', 3010

puts "Write a submission id: "
subm = gets
s.puts subm

s.close
