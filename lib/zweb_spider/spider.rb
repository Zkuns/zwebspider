require './threadpool.rb'

class Spider
  def initialize url, config
    @stackdeep = config[:stackdeep] || 3
    @threadpool = ThreadPool.new(4, url, config[:stackdeep])
  end

  def search
    @threadpool.run
    @threadpool.release
  end

end

spider = Spider.new('http://www.geekpark.net', {stackdeep: 2, retry_time: 0})
spider.search
