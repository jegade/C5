
use strict;
use warnings;

use Data::Printer;
use Test::More;                      # last test to print


BEGIN { use_ok( 'C5::Storage::Tree' ); }


my $tree = new_ok( 'C5::Storage::Tree' );

my $trees = C5::Storage::Tree->get_trees_by_instance();

p $trees;


done_testing();
