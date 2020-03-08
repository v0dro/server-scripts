module ServerScripts
  module Parser
    module VTune
      module Hotspots
        class SLATE < Threads
          # fname - CSV file containing output of vtune profiler.
          # nthreads - Number of threads to consider.
          def initialize fname, nthreads:
            @num_threads = nthreads
            super(fname)
          end

          # Get the total time for all threads under the header
          # "CPU Time:Spin Time:MPI Busy Wait Time". This time
          # is included within "CPU Time:Spin Time".
          def total_mpi_busy_wait_time
            @total_mpi_busy_time ||= parse_for_event(:mpi_busy_wait_time)
            @total_mpi_busy_time
          end

          private

          def parse_csv! fname
            data = CSV.parse(File.read(fname), headers: true)
            data.each_with_index do |row, i|
              @threads[i] = {}
              @threads[i][:cpu_time] = data[CPU_TIME][i].to_f
              @threads[i][:cpu_effective_time] = data[CPU_EFFECTIVE_TIME][i].to_f
              @threads[i][:cpu_overhead_time] = data[CPU_OVERHEAD_TIME][i].to_f
              @threads[i][:cpu_spin_time] = data[CPU_SPIN_TIME][i].to_f
              @threads[i][:wait_time] = data[WAIT_TIME][i].to_f
              @threads[i][:mpi_busy_wait_time] = data[MPI_BUSY_WAIT_TIME][i].to_f
              break if i == (@num_threads-1)
            end
          end
        end # class SLATE
      end # module Hotspots
    end # module VTune
  end # module Parser
end # module ServerScripts
