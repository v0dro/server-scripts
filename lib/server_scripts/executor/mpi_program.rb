# coding: utf-8
module ServerScripts
  module Executor
    class MPIProgram < Base
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
      def run_cmd
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
      
      def run_cmd
        hydra = @enable_itac ? "mpiexec.hydra -trace" : "mpiexec.hydra"
        cmd = "#{hydra} -ppn #{@npernode} -np #{@nprocs} "
        if @enable_itac
          cmd += "amplxe-cl -trace-mpi –collect hpc-performance –r #{@vtune_fname} "
        end

        cmd
      end
    end
    
  end
end
