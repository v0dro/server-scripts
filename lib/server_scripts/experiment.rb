module ServerScripts
  # Class that represents an experiment that needs to be conducted. Accepts
  # various parameters that need to be tested and a BatchJob object which it
  # customize depending on the test parameters.
  class Experiment
    attr_accessor :batch_job
    attr_accessor :exp_params
    attr_accessor :job_params
    attr_accessor :executable
    
    def initialize exp_name
      @exp_name = exp_name
    end

    
  end # class Experiment
end # module ServerScripts
