#!/usr/bin/perl

# Open the output file in write mode
open(my $fh, '>', $ARGV[1]) or die "Cannot open file: $!";

# Write a single line of assembly code to the file
print $fh "mov %rax, 1 # comment is here\n";

# Close the file
close($fh);

print "Assembly code has been written\n";
