require 'grpc'
require './types_services_pb'

class Counter < Types::ABCIApplication::Service

  def Echo(string, _call)
    Types::ResponseEcho.new(message: "ass #{string}")
  end

end

def main
  s = GRPC::RpcServer.new
  s.add_http2_port('localhost:46658', :this_port_is_insecure)
  s.handle(Counter)
  s.run_till_terminated
end

main
