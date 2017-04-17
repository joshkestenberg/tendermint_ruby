require 'grpc'
require './types_services_pb'

class Counter < Types::ABCIApplication::Service

  @serial = false
  @count = 0

  def echo(string, _call)
    Types::ResponseEcho.new(message: "#{string.message}")
  end

  def set_option(flag, _call)
    if flag.key == "serial"
      if flag.value == "on"
        @serial = true
        Types::ResponseSetOption.new(log: "serial is #{flag.value}")
      elsif flag.value == "off"
        @serial = false
        Types::ResponseSetOption.new(log: "serial is #{flag.value}")
      else
        Types::ResponseSetOption.new(log: "value must be either on or off")
      end
    else
      Types::ResponseSetOption.new(log: "request key must be 'serial'")
    end
  end

  def deliver_tx(trans, _call)
    # trans_data = trans.tx
    Types::ResponseDeliverTx.new(data: "3")
  end

end

def main
  s = GRPC::RpcServer.new
  s.add_http2_port('127.0.0.1:46658', :this_port_is_insecure)
  s.handle(Counter)
  s.run_till_terminated
end

main
