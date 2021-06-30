#!/bin/bash --login
#SBATCH --partition=htc
#SBATCH --ntasks=40
#SBATCH --time=2-12:00:00
#SBATCH -o batch_IO2.%A.out.txt
#SBATCH -e batch_IO2.%A.err.txt
#SBATCH --mail-user=daniel.wood@bangor.ac.uk
#SBATCH --mail-type=ALL

#S1 - takes reads from a basefile of paired_sequence_list.txt, the format of which is 
#/scratch/b.bssc1d/reads/very_long_name_1.fq.gz /scratch/b.bssc1d/reads/very_long_name_2.fq.gz	site1_individual2
#/scratch/b.bssc1d/reads/another_very_long_name_1.fq.gz /scratch/b.bssc1d/reads/another_very_long_name_2.fq.gz	site1_individual3
#etc. etc. :

#Cleans using IlluQC.pl and Trimmomatic, performs fastQC. 

export PERL5LIB=~/perl5/lib/perl5/
module add FastQC/0.11.8
module add trimmomatic/0.39
module load parallel

dir="/scratch/b.bssc1d/Independent_Origins_scratch";
fastqc="/home/b.bssc1d/FastQC/fastqc"
export TMPDIR=$dir;

base_names="/home/b.bssc1d/scripts/IndependentOrigins_SCW/paired_sequence_list.txt.out";

step3_complete="Example_S1_Progress.txt";

dat=$(date +%Y_%m_%d);

perl ~/scripts/IndependentOrigins_SCW/list_delete.pl $base_names $dir/$step3_complete Step_3_Complete $dat.4Step2; 

base_names=$base_names.del.$dat.4Step2;
date;

parallel -N 1 -j 40 --delay 0.2 --colsep '\t' "echo $dat Started {3} >> $dir/Example_S1_Progress.txt && perl ~/bin/NGSQCToolkit_v2.3.3/QC/IlluQC.pl -se {1} 1 A -l 70 -s 20 -t 1 -z g -o $dir && perl ~/bin/NGSQCToolkit_v2.3.3/QC/IlluQC.pl -se {2} 1 A -l 70 -s 20 -t 1 -z g -o $dir && echo $dat {3} Step _1_Complete >> $dir/Example_S1_Progress.txt && 
java -jar $TRIMMOMATIC PE $dir/{1/}_filtered.gz $dir/{2/}_filtered.gz SLIDINGWINDOW:4:15 MINLEN:70 -baseout $dir/{3}.fq.gz && $fastqc -o $dir $dir/{3}_1P.fq.gz && echo {3} Step_2_Complete >> $dir/Example_S1_Progress.txt && 
$fastqc -o $dir $dir/{3}_2P.fq.gz && echo $dat {3} Step_3_Complete >> $dir/Example_S1_Progress.txt"  :::: $base_names; 


