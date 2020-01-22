module ServerScripts
  module Computer
    class Base
      attr_accessor :node_type
        
      def full_node
        raise NotImplementedError
      end
    end    
  end
end
