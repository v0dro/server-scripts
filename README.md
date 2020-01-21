# server-scripts

A gem providing easily usable server scripts for various supercomputers and servers.
The following functionality is provided:

* Generate job scripts and run batch jobs on TSUBAME 3.0, ABCI and reedbush machines.
* Parse various kinds of profiling files and generate meaningful output.

# Usage

## ENV variables

Make sure the `SYSTEM` variable is set on your machine so that the gem will automatically
select the appropriate commands to run.

## Writing job scripts

### Simple openMPI job script

Use the `ServerScripts::BatchJob` class in your Ruby for outputting and submitting
job files. A simple MPI job can be generated and submitted as follows:

``` ruby
require 'server_scripts'

include ServerScripts

task = BatchJob.new do |t|
  t.nodes = 4
  t.npernode = 4
  t.wall_time = "1:30:00"
  t.out_file = "out.log"
  t.err_file = "err.log"
  t.node_type = NodeType::FULL
  t.mpi = OPENMPI
  t.set_env "STARPU_SCHED", "dmda"
  t.set_env "MKL_NUM_THREADS", "1"
  t.executable = "a.out"
  t.options = "3 32768 2048 2 2"
end

task.submit!
```
This will generate a unique file name and submit it using the system's batch
job submission command.

### Intel MPI profiling job script

If you want to generate traces using intel MPI, you can use additional options
like setting the ITAC and VTUNE output file/folder names.

## Parse intel ITAC output

The intel ITAC tool can be helpful for generating traces of parallel MPI programs.
This class can be used for converting an ITAC file to an ideal trace and then generating
the function profile for obtaining things like the MPI wait time.

For extracting the MPI wait time from an ITAC trace, do the following:
``` ruby
require 'server_scripts'

itac = ServerScripts::Parser::ITAC.new("itac_file.stf")
itac.generate_ideal_trace!

# All times are reported in seconds.

puts itac.mpi_time(kind: :ideal)
puts itac.mpi_time(kind: :real)
puts itac.event_time("getrf_start", how: :total, kind: :real)
puts itac.event_time("getrf_start", how: :per_proc, kind: :real)
```

## Parse starpu worker info


