module ServerScripts
  module Parser
    module VTune
      module Hotspots
        class SLATE < Threads
          def initialize fname, nthreads:
            @num_threads = nthreads
            super(fname)
          end

          def total_mpi_busy_time
            @total_mpi_busy_time ||= parse_for_event(:mpi_busy_time)
            @total_mpi_busy_time
          end

          private

          def parse_csv! fname
            data = CSV.parse(File.read(fname), headers: true)
            data.each_with_index do |row, i|
              break if i == (@num_threads-1)
              @threads[i] = {}
              @threads[i][:cpu_time] = data[CPU_TIME][i].to_f
              @threads[i][:cpu_effective_time] = data[CPU_EFFECTIVE_TIME][i].to_f
              @threads[i][:cpu_overhead_time] = data[CPU_OVERHEAD_TIME][i].to_f +
                data[CPU_SPIN_TIME][i].to_f
              @threads[i][:wait_time] = data[WAIT_TIME][i].to_f
              @threads[i][:mpi_busy_time] = data[MPI_BUSY_TIME][i].to_f
            end
          end
        end # class SLATE
      end # module Hotspots
    end # module VTune
  end # module Parser
end # module ServerScripts
