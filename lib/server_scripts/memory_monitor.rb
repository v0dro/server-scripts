module ServerScripts
  class MemoryMonitor
    attr_reader :pid
    attr_reader :pname
    attr_reader :duration_sec
    attr_reader :interval_sec
    attr_reader :vmrss
    attr_reader :vmsize
    
    def initialize(pid: nil, pname: nil, duration: "00:00:30", interval: "00:00:01")
      @vmrss = []
      @vmsize = []
      
      if pname.nil? && pid
        @pname = `ps -p #{pid} -o comm=`.strip
        @pid = pid
      end
      
      if pid.nil? && pname
        @pname = pname
        @pid = `pidof #{pname}`.strip.to_i
      end

      parse_time_intervals duration, interval
    end

    def start!
      @duration_sec.times do
        file = File.open "/proc/#{@pid}/status"
        file.each_line do |l|
          rss = l.match(/VmRSS:\s+(\d+)\s+kB/)
          @vmrss << (rss[1].to_i / 1e3) if rss

          size = l.match(/VmSize:\s+(\d+)\s+kB/)
          @vmsize << (size[1].to_i / 1e3) if size
        end

        sleep @interval_sec
      end
    end

    private

    def parse_time_intervals dur, inter
      hours, min, sec = get_hms(dur)
      @duration_sec = hours * 3600 + min * 60 + sec
      hours, min, sec = get_hms(inter)
      @interval_sec = hours * 3600 + min * 60 + sec
    end

    def get_hms(time)
      matcher = time.match(/(\d+):(\d+):(\d+)/)
      [matcher[1].to_i, matcher[2].to_i, matcher[3].to_i]
    end
  end # class MemoryMonitor
end # module ServerScripts
