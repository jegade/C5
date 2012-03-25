package C5::Root;

use strict;
use warnings;
use utf8;

use base 'Mojolicious::Controller';

sub auth {

    my $self = shift;
    return 1;
}

sub index {

    my $self = shift;

    $self->render( text => "Beispiel" )
}

1;
