module ServerScripts
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
    attr_accessor :reservation_id

    attr_reader :env
    attr_reader :job_fname
    attr_reader :system
    
    def initialize job_fname="sample_job.sh"
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
      @reservation_id = nil

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
      Kernel.system(@system.job_submit_cmd(
        batch_script: @job_fname,
        res_id: @reservation_id))
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
end
