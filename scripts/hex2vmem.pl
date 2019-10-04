#! /usr/bin/perl
# Convert to 32-bit Verilog memory file.

use warnings;
use strict;

while (<>) {
    s/(\w\w) (\w\w) (\w\w) (\w\w)/$4$3$2$1/g;
    print;
}
