require_relative 'test_helper'
include ServerScripts

class TestMachines < Minitest::Test
  def test_itac
    parser = Parser::ITAC.new("test/artifacts/PROF4_ITAC.STF")
    parser.trace!

    puts "MPI REAL ALL PROCS: #{parser.real_mpi_time}"
    puts "GETRF START REAL ALL PROCS: #{parser.event_time("getrf_start")}"
    puts "MPI IDEAL ALL PROCS: #{parser.ideal_mpi_time}"
  end

  def test_starpu_profile
    parser = Parser::StarpuProfile.new("test/artifacts/profile_file_DENSE_*.starpu_profile")

    puts parser.total_time
    puts parser.total_exec_time
    puts parser.total_sleep_time
    puts parser.total_overhead_time
  end
end
