require 'lib/computer'
require 'lib/tsubame'
require 'lib/abci'
require 'lib/lab_server'
require 'lib/reedbush'

module ServerScripts
  class << self
    def system
      sys = ENV["SYSTEM"]

      if sys == "SAMEER-PC"
        ServerScripts::SameerPC
      elsif sys == "TSUBAME"
        ServerScripts::TSUBAME
      end
    end
  end

  class TaskSubmit
    def initialize
      system = S
    end
    
  end
end



