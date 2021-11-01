use POSIX;
use strict;
my ($line, %hash);
my $base_file = $ARGV[0];
my $prev_file = $ARGV[1];
my $prev_string = $ARGV[2];
my $name = $ARGV[3];

my $basefile_nicename_pos = "0"; #Indicates which column your nice name is in your \t separated base file.
#Remember in perl the first column is 0, the second is 1, etc. etc.
my $prev_nicename_pos = "0";  #Indicates which column your nice name is in your " " separated progress file.

open(IN, "<$prev_file");
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	if ($line =~ m/$prev_string/){
		$hash{(split/ /, $line)[$prev_nicename_pos]} = "whatever";
	}
}
my $item;
foreach $item (keys %hash){
	print $item."\t";
}	
open(IN, "<$base_file");
open(OUT, ">$base_file.del.$name");
while(!eof(IN)){
	$line = readline *IN;
	chomp $line;
	if (exists $hash{(split/\t/, $line)[$basefile_nicename_pos]}){
	}else{
		print OUT $line."\n";
	}
}
