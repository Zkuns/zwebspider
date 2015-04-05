require 'threadpool'

class Spider
  def initialize config
    @stackdeep = config[:stackdeep] || 3
    @decoder = Decoder.new
    @threadpool = ThreadPool.new(url)
  end

  def search
    @threadpool.join
    @threadpool.release
  end


end
