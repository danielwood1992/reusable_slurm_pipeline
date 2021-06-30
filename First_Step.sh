#!/bin/bash --login
#SBATCH --partition=highmem
#SBATCH --ntasks=40
#SBATCH --time=2-12:00:00
#SBATCH -o FirstStep.%A.out.txt
#SBATCH -e FirstStep.%A.err.txt
#SBATCH --mail-user=your.name@bangor.ac.uk
#SBATCH --mail-type=ALL

####Above - set the time/memory resoures this step will need
#Can also be handy to mail yourself so you know when things have started

#1 Modules/setting up etc. 

export SOME_PATH=~/whatever/you/fancy/
module load module1
module load module2
module load parallel; #GNU parallel is very useful for this sort of thing...

dat=$(date +%Y_%m_%d); #I find it useful to record progress/make new lists by date, so you can keep track of what happened when.

#2 Set up path to your scratch, and directory with your base names etc. in it
dir="/path/to/your/scratch"; #This is where you'll direct your intermediate files etc. 
base_names="/path/to/your/example_base_file.txt"; 
script_path="/path/to/these/scripts"; #Directory where you've got all these scripts.

#3 Accessing the progress file for the first step...
this_step="/path/to/your/first_step_progress.txt"; #This will be the file that has records of the progress across your previous runs of this script...

#This step will read your $first_step file, and make a note of the files that have finished (see below). 
#It will then create a temporary base name file ($base_names.del.$dat.FtoDo) which will be the files that have not yet
#completed the first step.

#Arguments needed for list_delete.pl are 1) your base name file, 2) your this_step progress file, 3) a file extension for the temporary base_names file that will be launched in this run. 
perl $script_path/list_delete.pl $base_names $this_step First_Step_Complete $dat.FtoDo;

#Can then reset your basenames file variable for this script to be the one that needs doing..
base_names=$base_names.del.FtoDo;

#Some example commands in GNU parallel.
parallel -N 1 -j 40 --delay 0.2 --colsep '\t' "echo {3} $dat Started >> $first_step && 
module1 -1 {1} -2 {2} | module2 - - > {3}.Step1 && echo {3} $dat First_Step_Complete >> $first_step" :::: $base_names;

#Note - read gnu parallel manual to get the full list of options. 
#Basically, using the --colsep '\t' options means you split each line of your input file $base_names by '\t', then can use the individual elements as {1}, {2}, {3} for whatever steps you want.
 
#Important: the list_*.pl scripts assume that your "Nice Name"/identifier for each set of files will be in column 3 in the base_names file (\t separated) and column 1 in your $first_step file. You can change this by modifying what you echo out to your progress file, and with a bit of alteration to the list_*.pl files.

#You can also add intermediate steps of updating your Progress file at the end of substeps (e.g. substep1 {3} && echo {3} $dat Substep_1_Complete >> $first_step && subsetep2 {3} && ... etc. Useful for when the pipeline is going wrong somewhere but you don't know where.
