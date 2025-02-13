#!/usr/bin/perl

# Open the output file in write mode
open(my $fh, '>', 'assembly.s') or die "Cannot open file: $!";

# Write a single line of assembly code to the file
print $fh "mov rax, 1   ; This is a simple Linux x86_64 assembly instruction\n";

# Close the file
close($fh);

print "Assembly code has been written to assembly.s\n";