require_relative 'test_helper'
include ServerScripts

class TestMachines < Minitest::Test
  def test_itac
    parser = Parser::ITAC.new("test/artifacts/PROF4_ITAC.STF")
    parser.generate_ideal_trace!
  end

  def test_starpu_profile
    parser = Parser::StarpuProfile.new("test/artifacts/profile_file_DENSE_*.starpu_profile")

    puts parser.total_time
    puts parser.total_exec_time
    puts parser.total_sleep_time
    puts parser.total_overhead_time
  end
end
