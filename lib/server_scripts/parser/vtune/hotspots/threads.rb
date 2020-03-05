module ServerScripts
  module Parser
    module VTune
      # Classes for analysing files showing hotspot analysis.
      module Hotspots
        # Parse a file with a hotspots report and grouped by threads. This class
        # is made for parsing things from a single node, multi threaded execution.
        # CSV delimiter should be a comma.
        # 
        # Example command:
        # vtune -collect threading -report hotspots -group-by thread -csv-delimiter=, a.out 65536
        class Threads < Base
          # Get time for a particular event in a particular thread.
          def time event:, tid:
            @threads[tid][event]
          end

          # Sum of total CPU and wait time.
          def total_time
            total_cpu_time + total_wait_time
          end
          
          # Total CPU time of all the threads. Does not include the wait time.
          def total_cpu_time
            @total_cpu_time ||= parse_for_event(:cpu_time)
            @total_cpu_time
          end
          
          # Total Effective CPU time.
          def total_cpu_effective_time
            @total_cpu_effective_time ||= parse_for_event(:cpu_effective_time)
            @total_cpu_effective_time
          end
          
          # Total CPU overhead: sum of CPU Spin Time + CPU Overhead Time
          def total_cpu_overhead_time
            @total_cpu_overhead_time ||= parse_for_event(:cpu_overhead_time)
            @total_cpu_overhead_time
          end
          
          # Total Wait Time.
          def total_wait_time
            @total_wait_time ||= parse_for_event(:wait_time)
            @total_wait_time            
          end

          private

          def parse_csv! fname
            data = CSV.parse(File.read(fname), headers: true)
            data.each_with_index do |row, i|
              @threads[i] = {}
              @threads[i][:cpu_time] = data[CPU_TIME][i].to_f
              @threads[i][:cpu_effective_time] = data[CPU_EFFECTIVE_TIME][i].to_f
              @threads[i][:cpu_overhead_time] = data[CPU_OVERHEAD_TIME][i].to_f +
                data[CPU_SPIN_TIME][i].to_f
              @threads[i][:wait_time] = data[WAIT_TIME][i].to_f
            end
          end
        end # class Threads
      end # module Hotspots
    end # class ITAC
  end # module Parser
end # module ServerScripts
