require 'web_socket'
require 'rubygems'
require 'file/tail'

WebSocket.debug = true
server = WebSocketServer.new(:port => 10081, :accepted_domains => ["*"])
puts "Server running on #{server.port}"
server.run() do |ws|
  puts "Connection accepted: #{ws.path} #{ws.origin}"
  # The block is called for each connection.
  # Checks requested path.
  if ws.path == "/"
    # Call ws.handshake() without argument first.
    ws.handshake()
    
    filename = "/Users/jch/projects/fortius-issuemapper/log/development.log"
    puts "loading #{filename}"
    # while true
      File.open(filename) do |log|
        log.extend(File::Tail)
        log.interval = 10
        log.backward(10)
        log.tail do |line|
          ws.send(line) unless line =~ /^\s+$/  # blank line
        end
      end
    # end

    # Receives one message from the client as String.
    # while data = ws.receive()
    #   puts(data)
    #   # Sends the message to the client.
    #   ws.send(data)
    # end
  else
    # You can call ws.handshake() with argument to return error status.
    ws.handshake("404 Not Found")
  end
  puts("Connection closed")
end
