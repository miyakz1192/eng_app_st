
this_dir = File.expand_path(File.dirname(__FILE__))
lib_dir = File.join(this_dir, 'lib/proto')
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'grpc'
require './lib/proto/sentence_services_pb.rb'
require './lib/proto/sentence_pb.rb'

class SentenceServer < SentenceService::Service
  def list_by_worst(user)
    Sentences.new(message: [Sentence.new])
  end
end


#from rails c
#load "app/grpc/sentence_server.rb"
