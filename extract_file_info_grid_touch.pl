#!/usr/bin/env perl
while (<>) {
    if (/dana_rest/) {
	#print;
	chomp;
	@tok0 = split(/dana_rest_/);
	#print "$tok0[1]\n";
	@tok1 = split(/.hddm/, $tok0[1]);
	#print "$tok1[0]\n";
	@tok2 = split(/_/, $tok1[0]);
	print "touch file_${tok2[0]}_${tok2[1]}.dat\n";
    }
}
exit;
