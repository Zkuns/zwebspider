require 'nokogiri'
require 'open-uri'

class Decoder
  def initialize time
    @retry_time = time
    # @database = Datebase.new
  end

  #find initialize url
  def parse url
    @retry_time
    begin
      file = open url
      sleep 1
    rescue Exception=>e
      retry if @retry_time > 0
      puts e
      @retry_time -= 1
      sleep 2
    end
    # @database.save file
    doc = Nokogiri::HTML(file)
    links = doc.css('a').map do |a_tag|
      a_tag['href']
    end
    links
  end

end