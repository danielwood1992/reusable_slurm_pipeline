#!/bin/bash --login
#SBATCH --partition=htc
#SBATCH --ntasks=4
#SBATCH --time=12:00:00
#SBATCH -o IntermediateStep.%A.out.txt
#SBATCH -e IntermediateStep.%A.err.txt
#SBATCH --mail-user=your.name@bangor.ac.uk
#SBATCH --mail-type=ALL

####Above - set the time/memory resoures this step will need.
#Split things into separate scripts if they a) take different memory requirements, or b) you suspect the previous step might take ages to run so you'll never reach the later steps in the pipeline.

#1 Modules/setting up etc. 

export SOME_OTHER_PATH=~/whatever/you/fancy/
module load module3
module load module4
module load parallel; #GNU parallel is very useful for this sort of thing...

#Whatever other variables used across all your parallel steps, e.g...
genome="/path/to/your/genome.fasta";
dat=$(date +%Y_%m_%d); #I find it useful to record progress/make new lists by date, so you can keep track of what happened when.

#2 Set up path to your scratch, and directory with your base names etc. in it
dir="/path/to/your/scratch"; #This is where you'll direct your intermediate files etc. 
base_names="/path/to/your/example_base_file.txt"; 
script_path="/path/to/these/scripts"; #Directory where you've got all these scripts.

#3 Accessing the progress file for the first step...
previous_step="/path/to/your/first_step_progress.txt"; #This will be the file that has records of the progress across your previous runs of this script...for this example, it's the first step
this_step="/path/to/your/intermediate_step_progess.txt" #This should be the progress file that indicates whether the base_name has completed this step (i.e. you don't want to re-run it)..

#This step will read your $first_step file, and make a note of the files that have finished (see below). 
#It will then create a temporary base name file ($base_names.del.$dat.FtoDo) which will be the files that have not yet
#completed the first step.
#Arguments needed for list_keepdelete.pl are 1) your base names, 2) your previous_step progress file, 3) the string that indicates a particular base file has completed the previous step 4) your this_step progress file, 5) the string that indicates this step in the pipeline has been completed (so you don't redo it) and 6) an extension for your temporary base_names file for this run. 
#This will create a temporary base_names file which has only things that have i) completed the previous step but ii) have not completed the current step, which will be called $base_names.kdel.YourExtension

perl $script_path/list_keepdelete.pl $base_names $first_step First_Step_Complete $last_step Intermediate_Step_Complete $dat.ItoDo;

#Can then reset your basenames file variable for this script to be the one that needs doing..
base_names=$base_names.kdel.$dat.ItoDo;

parallel -N 1 -j 2 --delay 0.2 --colsep '\t' "echo {3} $dat Started >> $this_step && 
module3 $dir/{3}.Step1 > $dir/{3}.Step2A && module4 $dir/{3}.Step2A -g $genome > $dir/{3}.Step2A.done && 
echo {3} $dat Intermediate_Step_Complete >> $this_step" :::: $base_names; 

#You'll have to look at the last output file from the previous step, presumably you'll want to do it in the next step;

#Important: the list_*.pl scripts assume your "Nice Name"/identifier for each set of files will be in clumn 3 in the base_names file (\t separated) and column 1 in your $first_step file. You can change this by modifying what you echo to your progress fle, and with a bit of alteration tothe list_*.pl files.

#Note - read gnu parallel manual to get the full list of options. list_*.pl scripts assume that your "Nice Name"/identifier for each set of files will be in column 3 in the base_names file (\t separated) and column 1 in your $first_step file. You can change this by modifying what you echo out to your progress file, and with a bit of alteration to the list_*.pl files. 
#You can also add intermediate steps of updating your Progress file at the end of substeps (e.g. substep1 {3} && echo {3} $dat Substep_1_Complete >> $first_step && subsetep2 {3} && ... etc. Useful for when the pipeline is going wrong somewhere but you don't know where.
