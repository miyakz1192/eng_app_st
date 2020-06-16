
this_dir = File.expand_path(File.dirname(__FILE__))
lib_dir = File.join(this_dir, 'lib/proto')
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'grpc'
require './lib/proto/sentence_services_pb.rb'
require './lib/proto/sentence_pb.rb'

class SentenceServer < Erpc::SentenceService::Service

  puts "Sentence Server!!!"
  def list_by_worst(user, _unused_call)
    `echo list_by_worst >> /tmp/list_by_worst`
    puts "list_by_worst called!!!"
    puts "user = #{user.inspect}"
    s1 = Erpc::Sentence.new(no:1, data: ["s1"])
    s2 = Erpc::Sentence.new(no:2, data: ["s2"])
    s = Erpc::Sentences.new(sentences: [s1, s2])
    return s
    #return Erpc::Sentence.new(no: 1, data: ["h", "e", "l", "l", "o", "!"])
  end
end


#from rails c
#load "app/grpc/sentence_server.rb"
