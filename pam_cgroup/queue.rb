require 'ruby-progressbar'

class Queue
  attr_accessor :threads, :size
  attr_accessor :max, :skip_tick, :skip_elapsed, :pbar

  def initialize(size = 5, *args)
    @size = size
    @threads = []
    Hash[*args].each do |k,v|
      send("#{k}=",v)
    end
    @mutex = Mutex.new
    @pbar = ProgressBar.create(total: max, format: "%t %a (%c/%C) [%B] %e")
  end

  def enqueue(&block)
    if threads.length >= size
      Process.waitpid2(threads.slice!(0))
    end
    tick
    threads << fork do
      yield
    end
  end

  def wait
    threads.each do |cpid|
      Process.waitpid2(cpid)
    end
  end

  def self.run(*args)
    stime = Time.now
    queue = Queue.new(*args)
    yield queue
    queue.wait
    elapsed = (Time.now - stime).to_f
    puts "Time Elapsed (s): #{elapsed}" unless queue.skip_elapsed
  end

  protected
  def tick
    pbar.increment
  end
end
