require "csv"

class StreamingController < ApplicationController
  def index
    conf = [
     [2,1.0],
     [3,0.6],
     [4,0.8],
    ]
    create_playlist("http://192.168.0.2:3001/", conf)
  end

protected

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
