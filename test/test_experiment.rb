require_relative 'test_helper'
include ServerScripts

class TestExperiment < Minitest::Test
  # exp = Experiment.new("hicma_blr_threads_ultimate") do |e|
  #   # parameters that vary in the experiment.
  #   exp.argv[0] = [3]                # BLR matrix only
  #   exp.argv[1] = [65536, 262144]    # N
  #   exp.argv[2] = [1024, 2048, 4096] # nleaf
  #   exp.argv[3] = [5]                # nprow
  #   exp.argv[4] = [5]                # npcol
  #   exp.argv[5] = ["new_blr_profile_test.csv"]
  #   exp.argv[6] = [""]

  #   exp.set_env "STARPU_SCHED", "dmda"
  #   exp.set_env "MKL_NUM_THREADS", "1"
    
  # end

  # task = BatchJob.new do |t|
    
  # end

  # exp.job_object = task

  # exp.submit!
end
