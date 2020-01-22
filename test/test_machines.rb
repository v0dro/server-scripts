require_relative 'test_helper'
include ServerScripts

class TestMachines < Minitest::Test
  def test_tsubame
    task = BatchJob.new("job_script.sh") do |t|
      t.nodes = 4
      t.npernode = 1
      t.job_name = "ULTRASCALE"
      t.out_file = "ULTRA_out.log"
      t.err_file = "ULTRA_err.log"
      t.node_type = NodeType::FULL
      t.mpi = :openmpi
      t.set_env "STARPU_SCHED", "dmda"
      t.set_env "MKL_NUM_THREADS", "1"
      t.executable = "a.out"
      t.exec_options = "3 32768 2048 2 2"
    end

    task.generate_job_script!
    task.submit!
  end
end
