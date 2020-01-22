module ServerScripts
  module Parser
    class ITAC
      attr_reader :ideal_trace_file, :real_trace_file
      
      def initialize itac_file
        @itac_file = itac_file
        @ideal_trace_file = nil
        @real_trace_file = nil
      end

      def generate_ideal_trace!
        
      end
    end # class ITAC
  end
end
