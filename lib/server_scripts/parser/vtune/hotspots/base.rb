module ServerScripts
  module Parser
    module VTune
      module Hotspots
        class Base
          CPU_TIME = "CPU Time"
          CPU_EFFECTIVE_TIME = "CPU Time:Effective Time"
          CPU_OVERHEAD_TIME = "CPU Time:Overhead Time"
          CPU_SPIN_TIME = "CPU Time:Spin Time"
          WAIT_TIME = "Wait Time"

          def initialize fname
            @threads = {}
            parse_csv! fname
          end
        end
      end # class Base
    end # module VTune
  end # module Parser
end # module ServerScripts
