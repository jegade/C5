#!perl 

use strict;
use warnings;
use utf8;

use FindBin qw($Bin);
use lib "$Bin/../lib";


use C5::Engine;
use C5::Engine::Instance;
use C5::Repository;

my $repository = C5::Repository->new();
$repository->init;

my $instance = C5::Engine::Instance->new( repository => $repository, title => "First instance", description => "Some example instance", authority => [ '127.0.0.1:8010', '127.0.0.1:8011' ] ) ;

$instance->store_to_repository();


