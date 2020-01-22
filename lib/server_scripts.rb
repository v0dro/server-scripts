# -*- coding: utf-8 -*-
require 'server_scripts/node_type'
require 'server_scripts/executor'
require 'server_scripts/computer'
require 'server_scripts/version'

module ServerScripts
  class << self
    def system
      sys = ENV["SYSTEM"]

      if sys == "SAMEER-PC"
        ServerScripts::Computer::SameerPC
      elsif sys == "TSUBAME"
        ServerScripts::Computer::TSUBAME
      elsif sys == "ABCI"
        ServerScripts::Computer::ABCI
      elsif sys == "REEDBUSH"
        ServerScripts::Computer::REEDBUSH
      end
    end

    def group_name
      ENV["GROUP_NAME"]
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
    attr_accessor :nprocs
    attr_accessor :run_cmd, :executor, :executable
    attr_accessor :additional_commands
    attr_accessor :enable_intel_itac
    attr_accessor :intel_vtune_fname

    attr_reader :env
    attr_reader :job_fname
    attr_reader :system
      
    def initialize job_fname
      @job_fname = "sample_job_script.sh"
      @job_name = "sample"
      @out_file = "sample_out"
      @err_file = "sample_err"
      @wall_time = "1:00:00"
      @node_type = NodeType::FULL
      @nodes = 1
      @npernode = 1
      @nprocs = nil
      @run_cmd = nil
      @executor = :vanilla
      @env = {}
      @executable = "./a.out"
      @job_script = ""
      @enable_intel_itac = false
      @additional_commands = []

      yield self
    end

    def set_env var, value
      raise ArgumentError, "Env #{var} is already set to #{value}." if @env[var]
      @env[var] = value
    end

    def generate_job_script!
      @system = ServerScripts.system.new(@node_type, @nodes, @job_name,
        @wall_time, @out_file, @err_file, @env)
      configure_executor!

      @job_script += @system.header
      @job_script += @system.env_setter
      @additional_commands.each do |c|
        @job_script += c + "\n"
      end
      @job_script += "#{@executor.run_cmd} #{@executable} #{@options}"
    end

    def submit!
      generate_job_script! unless @job_script
      File.write(@job_fname, @job_script)
#      system(@system.job_submit_cmd(batch_script: @job_fname))
    end

    private

    def configure_executor!
      check_process_counts
      @nprocs = @npernode * @nodes

      if @executor == :openmpi
        @executor = Executor::OpenMPI.new(npernode: @npernode, nprocs: @nprocs, env: @env)
      elsif @executor == :intel
        @executor = Executor::IntelMPI.new(npernode: @npernode, nprocs: @nprocs, env: @env)
        @executor.enable_itac = !!@enable_intel_itac
        @executor.vtune_fname = @intel_vtune_fname
      elsif @executor == :vanilla
        @executor = Executor::Vanilla.new
      else
        raise ArgumentError, "Cannot find MPI implementation #{@executor}."
      end
    end

    def check_process_counts
      if @nprocs && @nprocs != @npernode * @nodes
        raise ArgumentError, "Number of processes should be #{@npernode * @nodes} not #{@nprocs}"
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



