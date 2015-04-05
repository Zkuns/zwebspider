require 'thread'
require './decoder'
require 'pry'
class ThreadPool
  def initialize (num = 4, url, stackdeep)
    @base_url = url
    @lock1 = Mutex.new
    @lock2 = Mutex.new
    @queue = [url, -1]
    @queueb = Array.new
    @decoder = Decoder.new(0)
    @stackdeep = stackdeep
    @parseover = false
    @threads = (0...num).map do
      Thread.new do
        # begin
          while true
            links = get_from_queue
            sleep if links == []
            links.each do |link|
              if link == -1
                @stackdeep -= 1
                change_queue
                @parseover = true
                next
              end
              import_to_queue(@decoder.parse(link))
            end
          end
        # rescue Exception => e
        #   puts e
        # end
      end
    end
  end

  def run
    @threads.each(&:run)
    loop do 
      if @parseover
        return if @stackdeep == 0
        sleep 1
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
    @queue << -1
    @queueb = Array.new
  end

  def wakeup
    @threads.each(&:wakeup)
  end

  def import_to_queue links
    @lock1.synchronize do
      links.each do |link|
        @queueb << (@base_url + link.to_s)
      end
    end
  end

  def get_from_queue
    @lock2.synchronize do
      @queue.shift(5)
    end
  end
end
