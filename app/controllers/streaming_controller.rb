require "csv"
require 'grpc'
require 'erpc/sentence_services_pb.rb'
require "pp"


class StreamingController < ApplicationController
  def index
    user_id = 1 #default
    user_id = params[:user_id] if params[:user_id]
    #playlist instruction is follow form(array of array)
    #in one array, first element is sentence_no, second is pitch
    #conf = [
    # [2,1.0],
    # [3,0.6],
    # [4,0.8],
    #]
    #create_playlist's first arg is ts files's url 
    #                  second arg is below conf
    conf = sentence_to_playlist_instruction(sentences(user_id))
    create_playlist(ts_file_url, conf)
  end

protected

  def ts_file_url
    place = :remote
    url = ""
    puts "DEBUG: ts_file_url start"
    puts "#{request.remote_ip}"
    puts "#{request.env['HTTP_X_FORWARDED_FOR']}"
    puts "#{request.env['REMOTE_ADDR']}"
    puts "#{request.env['HTTP_CLIENT_IP']}"
    puts "==========================="
    pp request.inspect
    puts "-------------------------------------------------"
    puts request.env.keys.grep /ENVOY/
    puts "==========================="
    pp request.env.inspect
    puts "DEBUG: ts_file_url end"

    if place == :local
      url = "http://192.168.0.2:3001"
    else
      url = "http://miyakz1192.ddns.net:3001/"
    end 

    return url 
  end

  def sentence_to_entry(erpc_sentence)
    sentence_no = erpc_sentence.no
    score       = erpc_sentence.score 
    res = []
    res << [sentence_no, 1.0]
    res << [sentence_no, 0.8] if score < 0
    res << [sentence_no, 0.6] if score < -2 
    return res 
  end

  def sentence_to_playlist_instruction(erpc_sentences)
    puts "DEBUG inspect"

    res = []

    erpc_sentences.sentences.each do |s|
      res += sentence_to_entry(s)
    end
    puts "#{res.inspect}"

    return res
  end

  def sentences(user_id)
    puts "start client"
    stub = Erpc::SentenceService::Stub.new('eng-app-app-service:50051', :this_channel_is_insecure)
    u = Erpc::User.new({id: user_id})
  
    sentences = stub.list_by_worst(u)
    puts "end client"
    return sentences
  end

  def create_playlist(url, conf)
    new_playlist = []
    discontinuity_sequence = 0
    conf.each do |sentence_no, pitch|
      playlist = File.read("public/data/#{sentence_no}/#{pitch}/playlist.m3u8").split("\n")
    
      playlist = playlist[4, playlist.length]
      
    
      playlist = playlist.map{|e| e.gsub(/__URL__/, "#{url}/data/#{sentence_no}/#{pitch}/__URL__")}
      
      new_playlist = new_playlist + 
        ["#EXT-X-DISCONTINUITY-SEQUENCE:#{discontinuity_sequence}",
         "#EXT-X-DISCONTINUITY"] + playlist
    
      discontinuity_sequence += playlist.grep(/__URL__/).count
    end
    
    new_playlist = ["#EXTM3U",
                    "#EXT-X-VERSION:3",
                    "#EXT-X-TARGETDURATION:3",
                    "#EXT-X-MEDIA-SEQUENCE:0"] + new_playlist
    
    new_playlist = new_playlist + ["#EXT-X-ENDLIST\n"]
    
    File.write("public/new_playlist.m3u8", new_playlist.join("\n"))
  end
end
