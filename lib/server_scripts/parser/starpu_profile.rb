module ServerScripts
  module Parser
    class StarpuProfile
      attr_reader :total_time
      attr_reader :total_exec_time
      attr_reader :total_sleep_time
      attr_reader :total_overhead_time
      
      def initialize regex
        @regex = regex
        @total_time = 0.0
        @total_exec_time = 0.0
        @total_sleep_time = 0.0
        @total_overhead_time = 0.0

        extract_data_from_profiles
      end

      private

      def extract_data_from_profiles
        Dir.glob(@regex) do |fname|
          output = File.read(fname).split("\n")

          output.each do |line|
            match_data = line.match(/total\:\s+(\d+)\.\d+\sms\sexecuting\:\s(\d+).\d+\sms\ssleeping\:\s(\d+).\d+\sms\soverhead\s(\d+).\d+\sms/)

            if match_data
              exec_time = match_data[2].to_i

              if exec_time != 0
                @total_time += match_data[1].to_f
                @total_exec_time += exec_time.to_f
                @total_sleep_time += match_data[3].to_f
                @total_overhead_time += match_data[4].to_f
              end
            end
          end
        end

        @total_time /= 1e3
        @total_exec_time /= 1e3
        @total_sleep_time /= 1e3
        @total_overhead_time /= 1e3
      end
    end
  end
end # module StarpuProfile
