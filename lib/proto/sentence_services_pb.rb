# Generated by the protocol buffer compiler.  DO NOT EDIT!
# Source: lib/proto/sentence.proto for package 'erpc'

require 'grpc'
require './lib/proto/sentence_pb'

module Erpc
  module SentenceService
    # CosmosService is microservices composed of a suite of small and lightweight services.
    class Service

      include GRPC::GenericService

      self.marshal_class_method = :encode
      self.unmarshal_class_method = :decode
      self.service_name = 'erpc.SentenceService'

      rpc :ListByWorst, User, Sentence
    end

    Stub = Service.rpc_stub_class
  end
end
