require 'open-uri'

class Decoder
  def initialize time
    @retry_time = time
    @database = Datebase.new
  end

  #find initialize url
  def parse url
    @retry_time
    file = open url
    # @database.save file
    puts url if file.read.include?()
    doc = Nokogiri::HTML(file)
    links = doc.css('a').each do |a_tag|
      a_tag['href']
    end
  end

end