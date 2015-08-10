require 'socket'
require 'json'

server = TCPServer.open(3000)
loop do
  client = server.accept
  $/ = "END"
  message = client.gets[0..-4]
  $/ = "\n"
  print message
  request = message.split("\r\n")[0].chomp
  verb = request.split(' ')[0]
  path = request.split(' ')[1]
  version = request.split(' ')[2]
  response = []
  case verb
  when "GET"
    begin
      File.readlines(".#{path}", "r").each { |line| response.push(line) }
      body = response.join("\r\n")
      headers = ["#{version} 200 OK", "Date: #{Time.now.to_s}", "Content-Length: #{File.new(".#{path}", 'r').size}", "\r\n"]
      response =  headers.join("\r\n") + body
    rescue
      response = "#{version} 404 Not Found\r\n"
    end
  when "POST"
    begin
      params = JSON.parse(message.split("\r\n")[-1])
      content = []
      params['viking'].each do |key, value|
        content.push("<li>#{key.capitalize}: #{value}</li>")
      end
      File.readlines(".#{path}", "r").each do |line|
        line.gsub!("<%= yield %>", content.join("\r\n"))
        response.push(line)
      end
      body = response.join("\r\n")
      headers = ["#{version} 200 OK", "Date: #{Time.now.to_s}", "Content-Length: #{File.new(".#{path}", 'r').size}", "\r\n"]
      response = headers.join("\r\n") + body
#    rescue
#      response = "#{version} 404 Not Found\r\n"
    end
  end
  client.print response
  client.close
print "\r\n\r\n"
end
