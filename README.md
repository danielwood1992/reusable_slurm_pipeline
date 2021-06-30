# reusable_slurm_pipeline
Pipeline mostly in shell where a series of files (e.g. paired NGS reads) are put through a number of SLURM submission scripts; lists record which files have succesfully completed which steps, and intermediate steps create new lists of files that have been through Step N-1 but not N+1, and run these. 
