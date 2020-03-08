module ServerScripts
  module Parser
    module VTune
      module Hotspots
        class Base
          CPU_TIME = "CPU Time"
          CPU_EFFECTIVE_TIME = "CPU Time:Effective Time"
          CPU_OVERHEAD_TIME = "CPU Time:Overhead Time"
          CPU_SPIN_TIME = "CPU Time:Spin Time"
          MPI_BUSY_WAIT_TIME = "CPU Time:Spin Time:MPI Busy Wait Time"
          WAIT_TIME = "Wait Time"

          def initialize fname
            @threads = {}
            parse_csv! fname
          end

          protected
          
          def parse_for_event event
            total = 0.0
            @threads.each_value do |thread|
              total += thread[event]
            end
            total
          end
        end
      end # class Base
    end # module VTune
  end # module Parser
end # module ServerScripts
