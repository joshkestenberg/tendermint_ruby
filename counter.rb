require 'grpc'
require './types_services_pb'

class Counter < Types::ABCIApplication::Service

  def echo(string, _call)
    Types::ResponseEcho.new(message: "#{string.message}")
  end

end

def main
  s = GRPC::RpcServer.new
  s.add_http2_port('127.0.0.1:46658', :this_port_is_insecure)
  s.handle(Counter)
  s.run_till_terminated
end

main
