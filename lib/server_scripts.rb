# -*- coding: utf-8 -*-
require 'server_scripts/node_type'
require 'server_scripts/executor'
require 'server_scripts/computer'
require 'server_scripts/version'

module ServerScripts
  class << self
    def system
      sys = ENV["SYSTEM_NAME"]

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
    attr_accessor :source_bashrc
    attr_accessor :modules

    attr_reader :env
    attr_reader :job_fname
    attr_reader :system
      
    def initialize job_fname
      @job_fname = job_fname
      @job_name = "sample"
      @out_file = "sample_out.log"
      @err_file = "sample_err.log"
      @wall_time = "1:00:00"
      @node_type = NodeType::FULL
      @nodes = 1
      @npernode = 1
      @nprocs = nil
      @run_cmd = nil
      @executor = :vanilla
      @env = {}
      @executable = "./a.out"
      @job_script = nil
      @enable_intel_itac = false
      @additional_commands = []
      @modules = []
      @source_bashrc = true

      yield self
    end

    def set_env var, value
      raise ArgumentError, "Env #{var} is already set to #{value}." if @env[var]
      @env[var] = value
    end

    def write_job_script!
      generate_job_script! unless @job_script
      File.write(@job_fname, @job_script)      
    end
    
    def submit!
      write_job_script!
      Kernel.system(@system.job_submit_cmd(batch_script: @job_fname))
    end

    private

    def generate_job_script!
      @system = ServerScripts.system.new(@node_type, @nodes, @job_name,
        @wall_time, @out_file, @err_file, @env, @modules)
      configure_executor!

      @job_script = ""
      @job_script += @system.header
      @job_script += "\nsource ~/.bashrc\n" if @source_bashrc
      @job_script += @system.module_load_cmd

      @job_script += @system.env_setter
      @additional_commands.each do |c|
        @job_script += c + "\n"
      end
      @job_script += "#{@executor.run_cmd} #{@executable} #{@options}\n"
    end

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

    class StarpuProfile
      attr_reader :total_time
      attr_reader :total_exec_time
      attr_reader :total_sleep_time
      attr_reader :total_overhead_time
      
      def initialize regex
        @regex = regex
        @total_time = 0.0
        @total_exec_time = 0.0
        @total_sleep_time = 0.0
        @total_overhead_time = 0.0

        extract_data_from_profiles
      end

      private

      def extract_data_from_profiles
        Dir.glob(@regex) do |fname|
          output = File.read(fname).split("\n")

          output.each do |line|
            match_data = line.match(/total\:\s+(\d+)\.\d+\sms\sexecuting\:\s(\d+).\d+\sms\ssleeping\:\s(\d+).\d+\sms\soverhead\s(\d+).\d+\sms/)

            if match_data
              exec_time = match_data[2].to_i

              if exec_time != 0
                @total_time += match_data[1].to_f
                @total_exec_time += exec_time.to_f
                @total_sleep_time += match_data[3].to_f
                @total_overhead_time += match_data[4].to_f
              end
            end
          end
        end

        @total_time /= 1e3
        @total_exec_time /= 1e3
        @total_sleep_time /= 1e3
        @total_overhead_time /= 1e3
      end
    end # class StarpuProfile
  end # module Parser
end # module ServerScripts



