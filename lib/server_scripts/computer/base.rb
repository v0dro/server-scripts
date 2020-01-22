module ServerScripts
  module Computer
    class Base
      def initialize(node_type, nodes, job_name, wall_time, out_file,
        err_file, env, modules)
        @node_type = node_type
        @nodes = nodes
        @job_name = job_name
        @wall_time = wall_time
        @out_file = out_file
        @err_file = err_file
        @env = env
        @modules = modules
      end

      def node_type
        if @node_type == NodeType::FULL
          self.class::FULL_NODE
        end
      end

      def env_setter
        raise NotImplementedError
      end
    end    
  end
end
