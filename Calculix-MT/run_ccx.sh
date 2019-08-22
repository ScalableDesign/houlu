#!/bin/bash
# lance un calcul CCX en mettant en place le multithreading

export OMP_NUM_THREADS=`nproc`
export CCX_NPROC_RESULTS=`nproc`
export CCX_NPROC_EQUATION_SOLVER=`nproc`
export NUMBER_OF_CPUS=`nproc`

ccx_2.15_MT $*