module ServerScripts
  module Parser
    class ITAC
      attr_accessor :ideal_itac_fname, :real_itac_fname
      
      def initialize itac_file
        check_for_traceanalyzer
        
        @real_trace_file = itac_file        
        @ideal_trace_file = nil

        yield self
      end

      def generate_ideal_trace!
        
      end

      private

      def check_for_traceanalyzer
        unless File.which("traceanalyzer")
          raise RuntimeError, "Must have intel traceanalyzer executable installed."
        end
      end
    end # class ITAC
  end
end
