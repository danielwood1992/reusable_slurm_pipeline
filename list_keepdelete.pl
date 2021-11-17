use POSIX;
use strict;
my ($line, %hash);
my $base_file = $ARGV[0]; #This is the file you want to keep stuff from...
my $prev_file = $ARGV[1];
my $prev_string = $ARGV[2]; #String that matches your input file... e.g. "Step_3_Complete";
my $next_file = $ARGV[3];
my $next_string = $ARGV[4];
my $name = $ARGV[5]; #A name to give the temp file - presumably the date plus step. 

my $prev_nicename_pos = "0";
my $next_nicename_pos = "0";
my $basefile_nicename_pos = "0";
#See list_delete.pl for an explanation of the above.

my (%keep_hash, %remove_hash);

open(IN, "<$prev_file");
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	if ($line =~ m/\Q$prev_string\E/){
		$keep_hash{(split/ /, $line)[$prev_nicename_pos]} = "whatever";
	}
}

open(IN, "<$next_file");
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	if ($line =~ m/\Q$next_string\E/){
		print "woof\n";
		$remove_hash{(split/ /, $line)[$next_nicename_pos]} = "whatever";

	}
}

#So then you have a list of hashes for a) things you need to keep, and b) a [presumabyl subset of a)] list of things to remove as they've already been completed in the next step.
	
open(IN, "<$base_file");
open(OUT, ">$ARGV[0].kdel.$name");
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	if (exists $keep_hash{(split/\t/, $line)[$basefile_nicename_pos]}){
		#If it exists in the Step N-1 complete files....maybe include it...
		if (exists $remove_hash{(split/\t/, $line)[$basefile_nicename_pos]}){
		#...unless it exists in the Step N+1 complete file, in which case it's already done. So don't do it. 
		}else{
			print OUT $line."\n";
		}
	}else{
	}
}
