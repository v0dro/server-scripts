module ServerScripts
  module Executor
    class Base
      def run_cmd
        raise NotImplementedError
      end
    end
  end  
end

