require "socket"

server = TCPServer.new("localhost", 3003)

def parse_request(request_line)
  http_method, path_and_query, http_version = request_line.split
  path, query = path_and_query.split('?')
  
  params = query.split('&')
  params.map! { |param| param.split('=') }
  params = params.to_h

  [http_method, path, params]
end

loop do
  client = server.accept

  request_line = client.gets
  next if !request_line || request_line =~ /favicon/
  # client.puts "HTTP/1.1 200 OK\r\n\r\n"
  puts request_line
 
  http_method, path, params = parse_request(request_line)

  client.puts "HTTP/1.0 200 OK"
  client.puts "Content-Type: text/html"
  client.puts
  
  client.puts "<html>"
  client.puts "<body>"
  client.puts "<pre>"
  client.puts http_method
  client.puts path
  client.puts params
  client.puts "</pre>"

  

  client.puts "<h1>Counter</h1>"
  client.puts "<p>The current number is #{number}</p>"

  client.puts "</body>"
  client.puts "</html>"

  client.close
end

