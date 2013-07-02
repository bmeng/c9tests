class Queue
  attr_accessor :threads, :size
  attr_accessor :max, :skip_tick, :skip_elapsed

  def initialize(size = 5, *args)
    @size = size
    @threads = []
    Hash[*args].each do |k,v|
      send("#{k}=",v)
    end
  end

  def enqueue(cmd = "", &block)
    if threads.length >= size
      Process.waitpid2(threads.slice!(0))
    end
    tick(cmd) unless skip_tick
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
  def tick(cmd)
    @iter ||= 0
    @iter += 1
    puts "#{cmd}: #{@iter}%s" % [max.nil? ? '' : " of #{max}"]
  end
end
