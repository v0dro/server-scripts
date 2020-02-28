require 'test_helper'
include ServerScripts

class TestMemoryMonitor < Minitest::Test
  def test_mem_monitor_pname
    monitor = MemoryMonitor.new(pname: "Xorg", duration: "00:30:00", interval: "00:01:00")
    monitor.start!

    puts monitor.vmrss
    puts monitor.vmsize
  end

  def test_mem_monitor_pid
    monitor = MemoryMonitor.new(pid: 1, duration: "00:10:00", interval: "00:01:00")
    monitor.start!

    puts monitor.vmrss
    puts monitor.vmsize
  end
end
