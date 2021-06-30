# reusable_slurm_pipeline

Pipeline in shell (with a couple of helper scripts in perl) where a series of files (e.g. paired NGS reads) are put through a number of SLURM submission scripts.
Generates intermediate lists which record which files have succesfully completed which steps. For the first step script, those which have already been run through
the first step are removed and the remaining files run. For the intermediate/final steps, those which have completed the previous step and not yet completed the 
current step are run. See files in the main repository with arbitrary commands etc. that explain the workflow.

This pipeline is useful when you have a large list of files that require a number of sequential steps doing to them, each of which may require multiple SLURM submission
scripts due to different memory requirements and/or run times. It can be hard to keep track of which files have completed which steps. 

Will add examples for an NGS pipeline (which is how I ended up writing it in the first place). 

Usage:

Once you've set up the files, start by running your First_Step.sh. Once some have finished running, you can then submit your Intermediate_Step.sh script. Repeat this
later for your remaining Intermediate_Step.sh or Final_Step.sh scripts. The intermediate files should keep track of which steps have finished, so you can re-run them
without modification until all the steps have been completed for all the files. 
