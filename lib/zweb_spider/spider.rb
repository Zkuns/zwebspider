class Spider
  def initialize config
    @queue = [[],[]]
    @lock = Mutex.new
    @stackdeep = config[:stackdeep] || 3
    @decoder = Decoder.new
    @threadpool = ThreadPool.new do
      
    end
  end

  def search url
    links = @decoder.parse url
    
  end

  def import_to_queue links
    @lock.synchronize do
      @queue[1] << links
    end
  end

  def get_from_queue
    @lock.synchronize do
      if @queue == []
        return 'EFO'
      end
      @queue[0].shift(5)
    end
  end
end
