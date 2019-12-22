#! /usr/bin/perl
# Convert to MIF

use warnings;
use strict;

my $addr;
my @data;

print <<EOL;
-- Quartus II generated Memory Initialization File (.mif)
WIDTH=32;
DEPTH=16384;
ADDRESS_RADIX=HEX;
DATA_RADIX=HEX;
CONTENT BEGIN
EOL

while (<>) {
    if (/^@(\w+)/) {
        $addr = hex($1);
        next;
    }
    
    s/(\w\w) (\w\w) (\w\w) (\w\w)/$4$3$2$1/g;
    @data = split(/\s/, $_);

    foreach (@data) {
        printf("%08X: %s;\n", $addr++, $_);
    }
}

print "END;\n"
