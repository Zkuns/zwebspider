require 'thread'

class ThreadPool
  def initialize (num = 4, &block)
    @threads = (0..num).map do
      Thread.new do
        begin
          yield
        rescue Exception => e
          puts e
        end
      end
    end
  end

  def join
    @threads.each(&:join)
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

  def stop
    @threads.each do |thread|
      thread.stop
    end
  end
end
