require 'test_helper'
include ServerScripts

class TestMemoryMonitor < Minitest::Test
  def test_mem_monitor_pname
    monitor = MemoryMonitor.new(pname: "Xorg", duration: "00:00:30", interval: "00:00:01")
    monitor.start!

    puts monitor.vmrss
    puts monitor.vmsize
  end

  def test_mem_monitor_pid
    monitor = MemoryMonitor.new(pid: 1, duration: "00:00:10", interval: "00:00:01")
    monitor.start!

    puts monitor.vmrss
    puts monitor.vmsize
  end
end
