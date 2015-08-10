require 'socket'

server = TCPServer.open(3000)
loop do
  client = server.accept
  request = client.gets
  verb = request.split(' ')[0]
  path = request.split(' ')[1]
  version = request.split(' ')[2]
  response = []
  begin
    case verb
    when "GET"
      File.readlines(".#{path}", "r").each { |line| response.push(line) }
      response = "#{version} 200 OK \r\n" + response.join("\r\n")
    end
  rescue
    response = "#{version} 404 Not Found\r\n"
  end
  client.print response
  client.close
end
