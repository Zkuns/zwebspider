require 'open-uri'

class Decoder
  def initialize time
    @retry_time = time
  end

  #find initialize url
  def parse url
    @retry_time
    file = open url
    save file
    doc = Nokogiri::HTML(file)
    links = doc.css('a').each do |a_tag|
      a_tag['href']
    end
  end

end