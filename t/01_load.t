
use strict;
use warnings;

use Test::More tests => 2;                      # last test to print


BEGIN { use_ok( 'C5::Repository' ); }


my $c5 = new_ok( 'C5::Repository' );

