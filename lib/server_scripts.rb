require 'server_scripts/computer.rb'
require 'server_scripts/tsubame'
require 'server_scripts/abci'
require 'server_scripts/lab_server'
require 'server_scripts/reedbush'

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
    end
  end
end



