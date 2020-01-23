module ServerScripts
  module Parser
    class StarpuProfile

      attr_reader :time_hash
      # Specify the regex that will allow finding the profile files for the given starpu
      # processes. Each process will output one file.
      #
      # Usage:
      #   parser = Parser::StarpuProfile.new("4_proc_profile_1_*.starpu_profile")
      #   parser.total_time
      def initialize regex
        @regex = regex
        @time_hash = {}
        extract_data_from_profiles
      end

      def total_time
        extract_from_time_hash :total_time
      end

      def total_exec_time
        extract_from_time_hash :exec_time
      end

      def total_sleep_time
        extract_from_time_hash :sleep_time        
      end

      def total_overhead_time
        extract_from_time_hash :overhead_time
      end

      def proc_time event:, proc_id:
        time = 0.0
        @time_hash[proc_id].each_value do |thread_info|
          time += thread_info[event]
        end

        time
      end

      def time event:, proc_id:, worker_id:
        @time_hash[proc_id][worker_id][event]
      end

      private

      def extract_from_time_hash key
        time = 0.0

        @time_hash.each_value do |proc_time|
          proc_time.each_value do |thread_time|
            time += thread_time[key]
          end
        end

        time
      end

      def extract_data_from_profiles
        Dir.glob(@regex) do |fname|
          proc_id = fname.match(@regex.gsub("*", "(\\d+)"))[1].to_i
          @time_hash[proc_id] = {}
          output = File.read(fname).split("\n")
          recent_cpu = nil
          
          output.each do |line|
            cpu_match = line.match(/CPU\s(\d+)/)
            recent_cpu = cpu_match[1].to_i if cpu_match
            match_data = line.match(/total\:\s+(\d+)\.\d+\sms\sexecuting\:\s(\d+).\d+\sms\ssleeping\:\s(\d+).\d+\sms\soverhead\s(\d+).\d+\sms/)

            if match_data
              exec_time = match_data[2].to_i
              if exec_time != 0
                @time_hash[proc_id][recent_cpu] = {}
                @time_hash[proc_id][recent_cpu][:total_time] = match_data[1].to_f / 1e3
                @time_hash[proc_id][recent_cpu][:exec_time] = match_data[2].to_f / 1e3
                @time_hash[proc_id][recent_cpu][:sleep_time] = match_data[3].to_f / 1e3
                @time_hash[proc_id][recent_cpu][:overhead_time] = match_data[4].to_f / 1e3
              end
              recent_cpu = nil
            end
          end
        end
      end
    end # class
  end # module Parser
end # module StarpuProfile
