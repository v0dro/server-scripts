module ServerScripts
  module Parser
    class Cubex
      # Supply the folder name of the cubex file. There should be a profile.cubex file
      # inside this folder.
      def initialize(fname)
        ['cube_stat', 'cube_info'].each do |cmd|
          raise RuntimeError, "Must have #{cmd} installed." unless File.which(cmd)
        end
        @fname = "#{fname}/profile.cubex"
        raise RuntimeError, "#{@fname} does not exist!"  unless File.exists?(@fname)
      end

      # Get the call tree of the file as a string.
      def call_tree
        `cube_info #{@fname}`
      end
      
      # Read the call tree and get the value for the given metric. Will return nil
      # if the said metric does not exist for the given event.
      def parse metric: , event:
        tree = `cube_info -m #{metric} #{@fname}`
        tree.each_line do |line|
          if /\s+#{event}\s+/.match(line)
            wo_space = line.gsub(" ", "")
            value = (/\|(\d+\.?\d+?)\|/.match(wo_space)[1]).to_f
            return value
          end
        end

        nil
      end

      # Return an array of all the metrics available for the given cubex file.
      def all_metrics
        output = `cube_info #{@fname} -l`
        output.split("\n")
      end
    end # class Cubex
  end # module Parser
end # module ServerScripts

