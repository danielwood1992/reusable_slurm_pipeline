# reusable_slurm_pipeline

Pipeline in shell (with a couple of helper scripts in perl) where a series of files (e.g. paired NGS reads) are put through a number of SLURM submission scripts.
Generates intermediate lists which record which files have succesfully completed which steps. For the first step script, those which have already been run through
the first step are removed and the remaining files run. For the intermediate/final steps, those which have completed the previous step and not yet completed the 
current step are run. See the First_Step.sh, Intermediate_Step.sh and Last_Step.sh scripts which go through an arbitrary example pipeline. 

This pipeline is useful when you have a large list of files that require a number of sequential steps doing to them, each of which may require multiple SLURM submission
scripts due to different memory requirements and/or run times. It can be hard to keep track of which files have completed which steps. 

The main files in this repository attempt to explain the principles behind the pipeline, and the example_NGS folder contains scripts from part of a pipeline going from raw reads to duplicate-marked bams as a working example. 
