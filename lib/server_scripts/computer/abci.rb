module ServerScripts
  module Computer
    class ABCI < Base
      FULL_NODE = "rt_F"
      
      def header(node_type: FULL_NODE)
        h = %q{
#!/bin/bash

#$ -cwd
#$ -l %{node_type}=%{nodes}
#$ -l h_rt=%{walltime}
#$ -N %{job_name}
#$ -o %{out_file}.log
#$ -e %{err_file}.log
        }
      end
    end    
  end
end

