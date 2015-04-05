require 'thread'
require 'decoder'

class ThreadPool
  def initialize (num = 4, url, stackdeep)
    @lock = Mutex.new
    @queue = Queue.new
    @queueb = Queue.new
    @decoder = Decoder.new
    @stackdeep = stackdeep
    @queue << url
    @threads = (0..num).map do
      Thread.new do
        begin
          while true
            links = get_from_queue
            sleep if links == []
            links.each do |link|
              import_to_queue(@decoder.parse link)
            end
          end
        rescue Exception => e
          puts e
        end
      end
    end
  end

  def join
    @threads.each(&:run)
    loop do 
      if check_finish?
        return if @stackdeep == 0
        @stackdeep -= 1
        change_queue
        wakeup
      end
      sleep 0.1
    end 
  end
  
  def release
    @threads.each(&:exit)
  end

  private
  
  def change_queue
    @queue = @queueb
    @queueb = Queue.new
  end

  def wakeup
    @threads.each(&:wakeup)
  end

  def check_finish?
    result = @threads.map do |thread|
      thread.status == 'sleep'
    end
    !result.include?(false)
  end

  def import_to_queue links
    @lock.synchronize do
      @queueb << links
    end
  end

  def get_from_queue
    @lock.synchronize do
      @queue[0].shift(5)
    end
  end
end
