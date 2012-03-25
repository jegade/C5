
use strict;
use warnings;

use Data::Printer;
use Test::More;                      # last test to print


BEGIN { use_ok( 'C5::Storage::Theme' ); }

my $tree = new_ok( 'C5::Storage::Theme' );

my $theme = C5::Storage::Theme->_make_basis_theme();


done_testing();
