require 'grpc'
require './types_services_pb'

class Counter < Types::ABCIApplication::Service

  @@serial = false
  @@count = 0
  @@commit_count = 0
  @@trans_count = 0

  def echo(string, _call)
    Types::ResponseEcho.new(message: "#{string.message}")
  end

  def info(app, _call)
    Types::ResponseInfo.new(data: "committed blocks: #{@@commit_count}, unhashed transactions: #{@@trans_count}")
  end

  def set_option(flag, _call)
    if flag.key == "serial"
      if flag.value == "on"
        @@serial = true
        Types::ResponseSetOption.new(log: "serial is #{flag.value}")
      elsif flag.value == "off"
        @@serial = false
        Types::ResponseSetOption.new(log: "serial is #{flag.value}")
      else
        Types::ResponseSetOption.new(log: "value must be either on or off")
      end
    else
      Types::ResponseSetOption.new(log: "request key must be 'serial'")
    end
  end

  def deliver_tx(trans, _call)
    array_count = 0
    byte_array = trans.tx.bytes
    byte_array.each {|byte| array_count += byte}

    if @@serial
      if array_count == @@count
        @@count += 1
        @@trans_count += 1
        Types::ResponseDeliverTx.new(code: :OK)
      else
        Types::ResponseDeliverTx.new(code: :BadNonce)
      end
    else
      @@trans_count += 1
      Types::ResponseDeliverTx.new(code: :OK)
    end

  end

  def check_tx(trans, _call)
    array_count = 0
    byte_array = trans.tx.bytes
    byte_array.each {|byte| array_count += byte}

    if @@serial
      if array_count == @@count
        Types::ResponseCheckTx.new(code: :OK)
      else
        Types::ResponseCheckTx.new(code: :BadNonce)
      end
    else
      Types::ResponseCheckTx.new(code: :OK)
    end

  end

  def commit(commit, _call)
    if @@trans_count > 0
      @@commit_count += 1

      last_byte = @@trans_count % 256

      byte_array = []
      x = 7

      7.times do |time|
        base = 256 ** x
        digit = @@trans_count / base
        @@trans_count -= digit * base
        byte_array << digit
        x -= 1
      end

      byte_array << last_byte
      byte_string = byte_array.pack("C*")

      Types::ResponseCheckTx.new(data: byte_string)
    else
      Types::ResponseCheckTx.new(log: "no transactions to commit")
    end
  end

  def begin_block(beg, _call)
    beg
  end

  def end_block(e, _call)
    e
  end

end

def main
  s = GRPC::RpcServer.new
  s.add_http2_port('127.0.0.1:46658', :this_port_is_insecure)
  s.handle(Counter)
  s.run_till_terminated
end

main
