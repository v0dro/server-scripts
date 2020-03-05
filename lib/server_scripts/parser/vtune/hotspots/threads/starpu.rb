module ServerScripts
  module Parser
    module VTune
      module Hotspots
        class Starpu < Threads
          # Get time for a particular event of a particular worker, master thread
          # or MPI thread. Specify :tid as :CPU_#ID for worker, :MPI for MPI thread,
          # and :master for the task submission thread.
          def time event:, tid:
            
          end

          private

          def parse_csv! fname
            
          end
        end # class Starpu
      end # module Hotspots
    end # module VTune
  end # module Parser
end # module ServerScripts
