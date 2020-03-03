module ServerScripts
  module Parser
    class StarpuProfile

      # The Hash containing the time records of various workers and processes.
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
        raise ArgumentError, "could not find any starpu profiles." if @time_hash.empty?
      end

      # Get the sum of total time in seconds summed over all processes and workers.
      def total_time
        extract_from_time_hash :total_time
      end

      # Get the sum of exec total time in seconds summed over all processes and workers.
      def total_exec_time
        extract_from_time_hash :exec_time
      end
      
      # Get the sum of sleep total time in seconds summed over all processes and workers.
      def total_sleep_time
        extract_from_time_hash :sleep_time        
      end

      # Get the sum of overhead total time in seconds summed over all processes and workers.
      def total_overhead_time
        extract_from_time_hash :overhead_time
      end

      # Get the total time for an event summed over all the workers in a given process.
      def proc_time event:, proc_id:
        time = 0.0
        @time_hash[proc_id].each_value do |thread_info|
          time += thread_info[event]
        end

        time
      end

      # Get the time in seconds for the given event, worker and process.
      # 
      # :event can be one of :total_time, :exec_time, :sleep_time or :overhead_time.
      # :proc_id should be a number specifying process number.
      # :worker_id should be a number specifying the worker ID.
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
        if ServerScripts.verbose
          puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
          puts "Parsing REGEX: #{@regex}"
        end
        
        Dir.glob(@regex) do |fname|
          if ServerScripts.verbose
            puts "--------------------------------------"
            puts "Reading file #{fname}..."
          end          
          proc_id = fname.match(@regex.gsub("*", "(\\d+)"))[1].to_i
          @time_hash[proc_id] = {}
          output = File.read(fname).split("\n")
          recent_cpu = nil

          puts("\tPROC ID: #{proc_id}") if ServerScripts.verbose
          
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
                if ServerScripts.verbose
                  puts("\t\tCPU ID: #{recent_cpu}")
                  puts("\t\t\tTotal Time: #{@time_hash[proc_id][recent_cpu][:total_time]}")
                  puts("\t\t\tExec Time: #{@time_hash[proc_id][recent_cpu][:exec_time]}")
                  puts("\t\t\tSleep Time: #{@time_hash[proc_id][recent_cpu][:sleep_time]}")
                  puts("\t\t\tOverhead Time: #{@time_hash[proc_id][recent_cpu][:overhead_time]}")
                end
              end
              recent_cpu = nil
            end
          end
          puts("--------------------------------------") if ServerScripts.verbose
        end
        puts("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<") if ServerScripts.verbose
      end
    end # class
  end # module Parser
end # module StarpuProfile
