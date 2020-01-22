# -*- coding: utf-8 -*-
require 'server_scripts/node_type'
require 'server_scripts/computer'
require 'server_scripts/version'

module ServerScripts
  class << self
    def system
      sys = ENV["SYSTEM"]

      if sys == "SAMEER-PC"
        ServerScripts::Computer::SameerPC.new
      elsif sys == "TSUBAME"
        ServerScripts::Computer::TSUBAME.new
      elsif sys == "ABCI"
        ServerScripts::Computer::ABCI.new
      elsif sys == "REEDBUSH"
        ServerScripts::Computer::REEDBUSH.new
      end
    end
  end

  module MPIType
    class MPIProgram
      attr_reader :npernode
      attr_reader :nprocs
      attr_reader :env
      
      def initialize(npernode: , nprocs:, env: {})
        @npernode = npernode
        @nprocs = nprocs
        @env = env
      end
    end
    
    class OpenMPI < MPIProgram
      def mpirun
        "mpirun --mca mpi_cuda_support 0 #{env_variables} -N #{@npernode} -np #{@nprocs}"
      end

      private

      def env_variables
        str = ""
        @env.each_key do |k|
          str += " -x #{k} "
        end
        
        str
      end
    end

    class IntelMPI < MPIProgram
      attr_accessor :enable_itac
      attr_accessor :vtune_fname

      def initialize(*args)
        super
        @vtune_fname = "DEFAULT_VTUNE"
      end
      
      def mpirun
        hydra = @enable_itac ? "mpiexec.hydra -trace" : "mpiexec.hydra"
        cmd = "#{hydra} -ppn #{@npernode} -np #{@nprocs} "
        if @enable_itac
          cmd += "amplxe-cl -trace-mpi –collect hpc-performance –r #{@vtune_fname} "
        end

        cmd
      end
    end  
  end

  class BatchJob
    attr_accessor :job_name
    attr_accessor :out_file
    attr_accessor :err_file
    attr_accessor :wall_time
    attr_accessor :node_type
    attr_accessor :options
    attr_accessor :nodes
    attr_accessor :npernode
    attr_accessor :nprocs, :run_cmd, :mpi, :executable

    attr_accessor :enable_intel_itac
    attr_accessor :intel_vtune_fname

    attr_reader :env
    attr_reader :job_fname
    attr_reader :system
      
    def initialize job_fname
      @system = ServerScripts.system
      @job_fname = "sample_job_script.sh"
      @job_name = "sample"
      @out_file = "sample_out"
      @err_file = "sample_err"
      @walltime = "1:00:00"
      @node_type = NodeType::FULL
      @nodes = 1
      @npernode = nil
      @nprocs = nil
      @run_cmd = nil
      @mpi = nil
      @env = {}
      @executable = "a.out"
      @job_script = ""
      @enable_intel_itac = false
    end

    def set_env var, value
      raise ArgumentError, "Env #{var} is already set to #{value}." if @env[var]
      @env[var] = value
    end

    def generate_job_script!
      configure_mpi!
      configure_node_type!

      @job_script += @system.header(node_type: @node_type)
    end

    def submit!
    end

    private

    def configure_mpi!
      if @mpi == :openmpi
        @mpi = MPIType::OpenMPI.new(npernode: @npernode, nprocs: @nprocs, env: @env)
      elsif @mpi == :intel
        @mpi = MPIType::IntelMPI.new(npernode: @npernode, nprocs: @nprocs, env: @env)
        @mpi.enable_itac = !!@enable_intel_itac
        @mpi.vtune_fname = @intel_vtune_fname
      else
        raise ArgumentError, "Cannot find MPI implementation #{@mpi}."
      end
    end

    def configure_node_type!
      if @node_type == NodeType::FULL
        @system.node_type = NodeType::FULL
      end
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
    end # class ITAC
  end # module Parser
end # module ServerScripts



