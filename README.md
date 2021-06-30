# reusable_slurm_pipeline

Pipeline in shell (with a couple of helper scripts in perl) where a series of files (e.g. paired NGS reads) are put through a number of SLURM submission scripts.
Generates intermediate lists which record which files have succesfully completed which steps. For the first step script, those which have already been run through
the first step are removed and the remaining files run. For the intermediate/final steps, those which have completed the previous step and not yet completed the 
current step are run. See the First_Step.sh, Intermediate_Step.sh and Last_Step.sh scripts which go through an arbitrary example pipeline. 

This pipeline is useful when you have a large list of files that require a number of sequential steps doing to them, each of which may require multiple SLURM submission
scripts due to different memory requirements and/or run times. It can be hard to keep track of which files have completed which steps. 

Usage:

Once you've set up your base_file with paths to your various files of interest, and modified the various sh scripts to make your pipeline, start by running your First_Step.sh. Once some have finished running, you can then submit your (first) Intermediate_Step.sh script. Repeat this later for your remaining Intermediate_Step.sh scripts or Final_Step.sh scripts. The progress files should keep track of which steps have finished for which, so you can re-run all of them without modification until all the steps have been completed for all the files. 


DW To Do:
Add example scripts for an NGS raw reads to vcf pipeline (which is how I ended up writing it in the first place). 
Make this README/the example scripts a bit more comprehensible.
