require 'grpc'
require 'sentence_services_pb'
require 'sentence_pb'

class SentenceServer < SentenceService::Service
  def list_by_worst(user)
    Sentences.new(message: [Sentence.new])
  end
end
