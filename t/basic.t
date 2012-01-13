use Mojo::Base -strict;

use Test::More tests => 4;
use Test::Mojo;

use_ok 'C5';

my $t = Test::Mojo->new('C5');
$t->get_ok('/welcome')->status_is(200)->content_like(qr/Mojolicious/i);
