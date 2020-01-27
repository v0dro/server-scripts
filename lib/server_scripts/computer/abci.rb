module ServerScripts
  module Computer
    class ABCI < Base

      HEADER = %q{
#!/bin/bash

#$ -cwd
#$ -l %{node_type}=%{nodes}
#$ -l h_rt=%{wall_time}
#$ -N %{job_name}
#$ -o %{out_file}
#$ -e %{err_file}

. /etc/profile.d/modules.sh
module load intel-mkl

      }
      FULL_NODE = "rt_F"

      MODULES = {
        "gcc" => "gcc",
        "intel-mpi" => "intel-mpi",
        "openmpi" => "openmpi",
        "itac" => "intel-itac intel-vtune"
      }
      
      def header
        HEADER % {node_type: node_type, nodes: @nodes, wall_time: @wall_time,
          job_name: @job_name, out_file: @out_file, err_file: @err_file}
      end

      def env_setter
        str = "\n"
        @env.each do |var, value|
          str += "export #{var}=#{value}\n"
        end

        str
      end

      def job_submit_cmd batch_script:, res_id: nil
        res = res_id ? " -ar #{res_id} " : ""
        "qsub -g #{ServerScripts.group_name} #{res} #{batch_script}"
      end

      def module_load_cmd
        "module load #{@modules.map { |m| MODULES[m] }.join(' ')}"
      end
    end    
  end
end

