# -*- coding: utf-8 -*-
require 'ptools'

require 'server_scripts/version'

require 'server_scripts/node_type'
require 'server_scripts/executor'
require 'server_scripts/computer'
require 'server_scripts/parser'
require 'server_scripts/experiment'
require 'server_scripts/batch_job'
require 'server_scripts/memory_monitor'

module ServerScripts
  class << self
    @@verbose = false
    def system
      sys = ENV["SYSTEM_NAME"]

      if sys == "SAMEER-PC"
        ServerScripts::Computer::SameerPC
      elsif sys == "TSUBAME"
        ServerScripts::Computer::TSUBAME
      elsif sys == "ABCI"
        ServerScripts::Computer::ABCI
      elsif sys == "REEDBUSH"
        ServerScripts::Computer::REEDBUSH
      end
    end

    def group_name
      ENV["GROUP_NAME"]
    end

    def verbose
      @@verbose
    end

    def verbose= v
      @@verbose = v
    end
  end
end # module ServerScripts



