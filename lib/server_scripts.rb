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

  module MPIType
    class MPIProgram
      
    end
    
    class OpenMPI < MPIProgram
      def mpirun
        "mpirun"
      end
    end

    class IntelMPI < MPIProgram
      def mpirun
        "mpiexec.hydra"
      end
    end
  end

  class NodeType
    FULL = :full
    HALF = :half
  end

  class BatchJob
    attr_accessor :job_name, :out_file, :err_file, :wall_time, :node_type
    attr_accessor :nodes, :npernode, :nprocs, :run_cmd, :mpi, :executable

    attr_reader :env
      
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
      @mpi = MPIType::OpenMPI.new
      @env = {}
      @executable = "a.out"
    end

    def set_env var, value
      raise ArgumentError, "Env #{var} is already set to #{value}." if @env[var]
      @env[var] = value
    end

    def submit!
    end
  end

  class Parser
    class ITAC
      attr_reader :ideal_trace_file, :real_trace_file
      
      def initialize itac_file
        @itac_file = itac_file
        @ideal_trace_file = nil
        @real_trace_file = nil
      end

      def generate_ideal_trace!
        
      end
    end
  end
end



