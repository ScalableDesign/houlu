#!/bin/bash
# Run CCX Version 2.15 Multithread with all the available processors
#

# Set the numbers of avaliable threads based on nproc (works in Container !)
export OMP_NUM_THREADS=`nproc`
export CCX_NPROC_RESULTS=`nproc`
export CCX_NPROC_EQUATION_SOLVER=`nproc`
export NUMBER_OF_CPUS=`nproc`

# Name of the fog file
timestamp=$(date "+%s")
log_filename="ccx_$timestamp.log"

# Run the computation, passing all the arguments and saving log output
echo "##################LOG-BEGIN###################" >> $log_filename
echo "Start: $(date -Iseconds)" >> $log_filename
echo "##################CCX-RUN#####################" >> $log_filename
/bin/ccx_2.15_MT $* >> $log_filename
echo "##################CCX-END#####################" >> $log_filename
echo "End: $(date -Iseconds)" >> $log_filename
duration = $(date "+%s") - $timestamp
echo "Duration: $duration" >> $log_filename
echo "##################LOG-END#####################" >> $log_filename