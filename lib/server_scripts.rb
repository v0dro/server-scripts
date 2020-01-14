require 'server_scripts/computer.rb'
require 'server_scripts/tsubame'
require 'server_scripts/abci'
require 'server_scripts/lab_server'
require 'server_scripts/reedbush'

module ServerScripts
  class << self
    def system
      sys = ENV["SYSTEM"]

      if sys == "SAMEER-PC"
        ServerScripts::SameerPC
      elsif sys == "TSUBAME"
        ServerScripts::TSUBAME
      elsif sys == "ABCI"
        ServerScripts::ABCI
      elsif sys == "REEDBUSH"
        ServerScripts::REEDBUSH
      end
    end
  end

  class TaskSubmit
    attr_accessor :job_name, :out_file, :err_file, :walltime, :node_type
    attr_accessor :nodes, :npernode, :nprocs, :run_cmd
      
    def initialize
      sys = ServerScripts.system
      
      @job_name = "sample"
      @out_file = "sample_out"
      @err_file = "sample_err"
      @walltime = "1:00:00"
      @node_type = sys::FULL_NODE
      @nodes = 1
      @npernode = nil
      @nprocs = nil
      @run_cmd = nil
    end

    def submit!
    end
  end
end



