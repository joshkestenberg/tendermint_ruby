# Generated by the protocol buffer compiler.  DO NOT EDIT!
# Source: types.proto for package 'types'

require 'grpc'
require './types_pb'

module Types
  module ABCIApplication
    # ----------------------------------------
    # Service Definition
    #
    class Service

      include GRPC::GenericService

      self.marshal_class_method = :encode
      self.unmarshal_class_method = :decode
      self.service_name = 'types.ABCIApplication'

      rpc :Echo, RequestEcho, ResponseEcho
      rpc :Flush, RequestFlush, ResponseFlush
      rpc :Info, RequestInfo, ResponseInfo
      rpc :SetOption, RequestSetOption, ResponseSetOption
      rpc :DeliverTx, RequestDeliverTx, ResponseDeliverTx
      rpc :CheckTx, RequestCheckTx, ResponseCheckTx
      rpc :Query, RequestQuery, ResponseQuery
      rpc :Commit, RequestCommit, ResponseCommit
      rpc :InitChain, RequestInitChain, ResponseInitChain
      rpc :BeginBlock, RequestBeginBlock, ResponseBeginBlock
      rpc :EndBlock, RequestEndBlock, ResponseEndBlock
    end

    Stub = Service.rpc_stub_class
  end
end
