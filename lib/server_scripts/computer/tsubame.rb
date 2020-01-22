module ServerScripts
  module Computer
    class TSUBAME < Base
      HEADER = %q{#!/bin/bash

#$ -cwd
#$ -l %{node_type}=%{nodes}
#$ -l h_rt=%{wall_time}
#$ -N %{job_name}
#$ -o %{out_file}
#$ -e %{err_file}
      }

      FULL_NODE = "f_node"
      
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
    end    
  end
end
