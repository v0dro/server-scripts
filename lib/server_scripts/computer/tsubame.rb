module ServerScripts
  module Computer
    class TSUBAME < Base
      HEADER = %q{
#!/bin/bash
#$ -cwd
#$ -l %{node_type}=%{nodes}
#$ -l h_rt=%{wall_time}
#$ -N %{job_name}
#$ -o %{out_file}.log
#$ -e %{err_file}.log
      }

      FULL_NODE = "f_node"
      
      def header(node_type: , nodes: 1,
        wall_time: "1:00:00", job_name: "sample",
        out_file: "out_file.out", err_file: "err_file.out")

        @node_type = node_type
        HEADER % {node_type: node_type, nodes: nodes, wall_time: wall_time,
          job_name: job_name, out_file: out_file, err_file: err_file}
      end

      def node_type
        if @node_type == NodeType::FULL
          FULL_NODE
        end
      end
    end    
  end
end
