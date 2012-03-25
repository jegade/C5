
use strict;
use warnings;

use Data::Printer;
use Test::More;                      # last test to print


BEGIN { use_ok( 'C5::Storage::Instance' ); }


my $instance = new_ok( 'C5::Storage::Instance' );


my $obj = C5::Storage::Instance->get_instance_by_domain;

isa_ok ($obj , 'C5::Storage::Instance', "Instance found");

ok( $obj->title, "Beispiel Instanz");

done_testing();

