
this_dir = File.expand_path(File.dirname(__FILE__))
lib_dir = File.join(this_dir, 'lib/proto')
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'grpc'
require './lib/proto/sentence_services_pb.rb'
require './lib/proto/sentence_pb.rb'

class SentenceServer < SentenceService::Service
  def list_by_worst(user)
    raise "TEST ERROR"
    `echo list_by_worst >> /tmp/list_by_worst`
    puts "list_by_worst called!!!"
    return Sentences.new({message: [Sentence.new({no: 1, score: 1})]})
  end
end


#from rails c
#load "app/grpc/sentence_server.rb"
