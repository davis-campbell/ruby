require 'socket'
require 'json'

puts "Would you like to send a GET or a POST request?"
verb = gets.chomp
print "Enter hostname: "
host = gets.chomp                   # The web server
if host == 'localhost'
  port = 3000
else
  port = 80
end                                 # Default HTTP port
print "Enter path: "
path = gets.chomp                   # The file we want
print "\r\n"

socket = TCPSocket.open(host,port)  # Connect to server
case verb
when "GET"
  request = "#{verb} #{path} HTTP/1.0\r\n\r\nEND"
  socket.print(request)               # Send request
  response = socket.read              # Read complete response
when "POST"
  puts "Welcome to raid registration. Please provide a name and e-mail address."
  print "Name: "
  name = gets.chomp
  print "E-mail: "
  email = gets.chomp
  data = {:viking => {:name => name, :email => email} }.to_json
  headers = ["#{verb} #{path} HTTP/1.0", "Content-Length: #{data.size}", "\r\n"]
  request = headers.join("\r\n") + data + "END"
  print request[0..-4] + "\r\n\r\n"
  socket.print(request)
  response = socket.read
end

print response
