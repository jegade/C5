package C5::Frontend;

use strict;
use warnings;
use utf8;

use base 'Mojolicious::Controller';

use Data::Printer;

sub view {

    my $self = shift;
    
    my $path = $self->stash('path');

    my $domain = $self->req->url->to_abs->authority;
    $self->render( text => "Beispiel ". $domain . " " . $path )
}

1;
