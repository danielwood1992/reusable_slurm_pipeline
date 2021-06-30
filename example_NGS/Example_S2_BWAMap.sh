#!/bin/bash --login
#SBATCH --partition=highmem
#SBATCH --ntasks=25
#SBATCH --time=2-12:00:00
#SBATCH -o batch_IO2.%A.out.txt
#SBATCH -e batch_IO2.%A.err.txt
#SBATCH --mem=25G
#SBATCH --mail-user=daniel.wood@bangor.ac.uk
#SBATCH --mail-type=ALL

#This script will take cleaned reads from S1, and map them to the genome using bwa-mem, and sort the output.

export PERL5LIB=~/perl5/lib/perl5/
module load parallel
module load bwa 
module load samtools
dir="/scratch/b.bssc1d/Independent_Origins_scratch";
base_names="/home/b.bssc1d/scripts/IndependentOrigins_SCW/paired_sequence_list.txt.out";
genome="/scratch/b.bssc1d/6Pop_Resequencing/TGS_GC_fmlrc.scaff_seqs.fa"

export TMPDIR=$dir;

dat=$(date +%Y_%m_%d);

#Ones to do:
#a) In Step_3_Complete in Example_S1_Progress.txt. 
#b) Not In Step_4_Complete.txt in Example_S2_Progress.txt;

step3_record="Example_S1_Progress.txt"; 
step4_record="Example_S2_Progress.txt";

#Need to find the ones of these that are done...

perl ~/scripts/IndependentOrigins_SCW/list_keepdelete.pl $base_names $dir/$step3_record Step_3_Complete $dir/$step4_record Step_4_Complete $dat.4ToDo 

base_names=$base_names.kdel.$dat.4ToDo;

parallel -N 1 -j 6 --delay 0.2 --colsep '\t' "echo {4} $dat Started >> $dir/Example_S2_Progress.txt && bwa mem -t 4 $genome $dir/{3}_1P.fq.gz $dir/{3}_2P.fq.gz | samtools sort -n -o $dir/{3}.sorted.bam - && echo {4} $dat Step_4_Complete >> $dir/Example_S2_Progress.txt" :::: $base_names.kdel.$dat.4ToDo;

