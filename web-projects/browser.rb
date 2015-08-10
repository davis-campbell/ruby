require 'socket'

print "Enter hostname: "
host = gets.chomp                   # The web server
if host == 'localhost'
  port = 3000
else
  port = 80
end                                 # Default HTTP port
print "Enter path: "
path = gets.chomp                   # The file we want 

# This is the HTTP request we send to fetch a file
request = "GET #{path} HTTP/1.0\r\n\r\n"

socket = TCPSocket.open(host,port)  # Connect to server
socket.print(request)               # Send request
response = socket.read              # Read complete response

print response
