require_relative 'test_helper'

class TestMachines < Minitest::Test
  def test_tsubame
    task = ServerScripts::TaskSubmit.new
    task.job_name = "awesome_job"
    task.out_file = "awesome_outfile"
    task.err_file = "awesome_errfile"

    task.submit!
  end
end
