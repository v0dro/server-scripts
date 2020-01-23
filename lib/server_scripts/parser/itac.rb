module ServerScripts
  module Parser
    class ITAC
      attr_accessor :real_itac_fname
      attr_reader :ideal_itac_fname
      
      def initialize itac_file
        check_for_traceanalyzer
        
        @real_itac_fname = itac_file        
        @ideal_itac_fname = "#{@real_itac_fname}.ideal.single.stf"
        @real_function_profile = nil
        @ideal_function_profile = nil

        yield self if block_given?
      end

      def trace!
        generate_ideal_trace!
        analyze_function_profiles!
      end

      def generate_ideal_trace!
        unless File.file?(@ideal_itac_fname)
          Kernel.system(
            "traceanalyzer --cli --ideal -u -o #{@ideal_itac_fname} #{@real_itac_fname}")
        end
      end

      def analyze_function_profiles!
        unless @real_function_profile
          @real_function_profile = `traceanalyzer --cli --functionprofile #{@real_itac_fname}`
          @real_function_profile = @real_function_profile.split("\n")
        end
        unless @ideal_function_profile
          @ideal_function_profile = `traceanalyzer --cli --functionprofile #{@ideal_itac_fname}`
          @ideal_function_profile = @ideal_function_profile.split("\n")          
        end
      end

      # Total time of real execution including intialization etc.
      def real_app_time
        @total_app_time ||= event_time("Application", kind: :real, how: :all_procs)
        @total_app_time
      end

      # Ideal MPI time. Only wait time.
      def ideal_mpi_time
        @ideal_mpi_time ||= event_time("MPI", kind: :ideal)
        @ideal_mpi_time
      end

      # Actual MPI time. Includes wait time and communication time.
      def real_mpi_time
        @real_mpi_time ||= event_time("MPI")
        @real_mpi_time
      end

      # Time that MPI spent in communication.
      def mpi_comm_time
        real_mpi_time - ideal_mpi_time
      end

      # Get event time for a particular event. Specify whether from ideal trace or real trace.
      def event_time(event, kind: :real, how: :all_procs)
        if kind == :real
          parse_real_event_time(event, how: how)
        elsif kind == :ideal
          parse_ideal_event_time(event, how: how)
        else
          raise ArgumentError, "kind argument should be either :real or :ideal, not #{kind}."
        end
      end

      private

      def get_allprocs_event_time(func_profile, event)
        regex_event = Regexp.quote(event)
        event_time = nil
        func_profile.each do |l|
          if l.match(/"All_Processes";"#{regex_event}"/)
            match_data = l.match /"All_Processes";"#{regex_event}";(\d+);(\d+);(\d+);(\d+)/
            event_time = match_data[2].to_f / 1e9
            break
          end
        end

        unless event_time
          raise RuntimeError, "no event #{event} could be found in the function profile"
        end

        event_time
      end

      def get_perproc_event_time(func_profile, event)
        regex_event = Regexp.quote(event)
        per_proc_event_time = {}

        func_profile.each do |l|
          if l.match(/"Process\s(\d+)";"#{regex_event}"/)
            match_data = l.match(/"Process\s(\d+)";"#{regex_event}";(\d+);(\d+);(\d+);(\d+)/)
            per_proc_event_time[match_data[1].to_i] = match_data[3].to_f / 1e9
          end
        end

        values = per_proc_event_time.values
        [values.inject(:+).to_f / values.size, values.min, values.max]
      end

      def parse_real_event_time(event, how:)
        if how == :all_procs
          get_allprocs_event_time(@real_function_profile, event)
        elsif how == :per_proc
          get_perproc_event_time(@real_function_profile, event)
        else
          raise ArgumentError, "how argument should be either :all_procs or :per_proc, not #{how}."
        end
      end

      def parse_ideal_event_time(event, how:)
        if how == :all_procs
          get_allprocs_event_time(@ideal_function_profile, event)
        elsif how == :per_proc
          get_perproc_event_time(@ideal_function_profile, event)
        else
          raise ArgumentError, "how argument should be either :all_procs or :per_proc, not #{how}."
        end
      end

      def check_for_traceanalyzer
        unless File.which("traceanalyzer")
          raise RuntimeError, "Must have intel traceanalyzer executable installed."
        end
      end
    end # class ITAC
  end
end
