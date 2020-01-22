module ServerScripts
  module Computer
    class Base
      def full_node
        raise NotImplementedError
      end
    end    
  end
end
