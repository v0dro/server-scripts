module ServerScripts
  class ABCI < Computer
    HEADER = %q{
#!/bin/bash

#$ -cwd
#$ -l %{node_type}=%{nodes}
#$ -l h_rt=%{walltime}
#$ -N %{job_name}
#$ -o %{out_file}.log
#$ -e %{err_file}.log
    }

    FULL_NODE = "rt_F"
  end
end
