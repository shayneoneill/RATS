require "socket"
require "db"
require "pg"
require "dotenv"


class LogEntry
  JSON.mapping(
    {
      device: String,
      severity: String,
      data: String
    }
  )
end

class UdpLogger
  def openListen
    envs = Dotenv.load
    server = UDPSocket.new
    print "BINDING\n"
    server.bind envs["HOST"], envs["PORT"].to_i
    return server
  end
    # Create client and connect to server
  def listen(server,&process_packet)
    ret = false
    #{}//if server != Nil
    #//  server.puts "Whatever"
    #{}//end
    packet = Slice(UInt8).new(1024)
    while !ret
      size,client_addr = server.receive(packet)
      if packet
        result = packet.map { |x| x.chr }.join
        ret = yield result[0..size-1]
      end
    end
  end
  # Close client and server
  def closeListen (server)
    if server
      server.close
    end
  end

end


class LoggerRunner

  def run
    envs = Dotenv.load
    puts (envs)
    DB.open envs["DATABASE"] do |db|
      runloop db
    end
  end

  def runloop (db)
    udp = UdpLogger.new
    server = udp.openListen
    print("Listening\n")
    udp.listen(server) do |packet|
      #print (packet)
      if packet
        entry = LogEntry.from_json(packet)
        #puts "#{entry.device} #{entry.severity} | #{entry.data}"
        begin
          db.exec "insert into logentries (host, severity, data) values ( $1 , $2 , $3 )",entry.device,entry.severity,entry.data
        rescue
          print "Database insert fail"
        end
        print "."
      end
    end
  end
end

lr = LoggerRunner.new
lr.run
