#!/bin/bash --login
#SBATCH --partition=htc
#SBATCH --ntasks=7
#SBATCH --time=1-12:00:00
#SBATCH -o batch_IO4.%A.out.txt
#SBATCH -e batch_IO4.%A.err.txt
#SBATCH --mail-user=daniel.wood@bangor.ac.uk
#SBATCH --mail-type=ALL

#This will fixmates and mark duplicates in the resulting bam files from the previous step.

export PERL5LIB=~/perl5/lib/perl5/
module load parallel
module load samtools

dir="/scratch/b.bssc1d/Independent_Origins_scratch";
base_names="/home/b.bssc1d/scripts/IndependentOrigins_SCW/paired_sequence_list.txt.out";
export TMPDIR=$dir;

keep_step4="Example_S2_Progress.txt";
remove_step5="Example_S3_Progress.txt";
dat=$(date +%Y_%m+%d);

perl ~/scripts/IndependentOrigins_SCW/list_keepdelete.pl $base_names $dir/$keep_step4 Step_4_Complete $dir/$remove_step5 Step_5_Complete $dat.5ToDo;

base_names=$base_names.kdel.$dat.5ToDo;

parallel -N 1 -j 6 --delay 0.2 --colsep '\t' "echo {3} Started >> $dir/Example_S3_Progress.txt && samtools fixmate -m -c $dir/{3}.sorted.bam - | samtools sort -o - - | samtools markdup - $dir/{3}.sorted.rmdp.bam && echo {3} $dat Step_5_Complete >> $dir/Example_S3_Progress.txt" :::: $base_names;
