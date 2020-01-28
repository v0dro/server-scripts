require_relative 'test_helper'
include ServerScripts

class TestMachines < Minitest::Test
  def test_itac
    parser = Parser::ITAC.new("test/artifacts/PROF4_ITAC.STF")
    parser.trace!
    puts parser.event_time("getrf_start", how: :per_proc, kind: :real)
    # puts "MPI REAL ALL PROCS: #{parser.real_mpi_time}"
    # puts "GETRF START REAL ALL PROCS: #{}"
    # puts "MPI IDEAL ALL PROCS: #{parser.ideal_mpi_time}"
  end

  def test_starpu_profile
    ServerScripts.verbose = true
    
    parser = Parser::StarpuProfile.new("test/artifacts/profile_file_DENSE_*.starpu_profile")

    puts parser.total_time
    puts parser.total_exec_time
    puts parser.total_sleep_time
    puts parser.total_overhead_time
  end

  def test_starpu_profile_load_balance
    parser = Parser::StarpuProfile.new("test/artifacts/4_proc_profile_8_*.starpu_profile")
    
    puts parser.total_time
    puts parser.total_exec_time
    puts parser.total_sleep_time
    puts parser.total_overhead_time
    puts parser.time(event: :total_time, proc_id: 0, worker_id: 4)
    puts parser.proc_time event: :exec_time, proc_id: 2
  end
end
