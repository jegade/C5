package C5::Dispatcher;

use strict;
use warnings;
use utf8;

use base 'Mojolicious::Controller';


sub view {

    my $self = shift;

    my $path = $self->stash('path');
    $path = "/".$path if index($path,"/") != 0;

    $self->app->log->debug("Path " . $path ) ;

    # Authority for the request domain.tld:port
    my $authority = $self->req->url->to_abs->authority;

    # URI
    my $uri = $self->req->url->clone;

    # Search the related instance for the domain:port
    my $response = $self->engine->get_response_for( $authority, $uri, $path ) ;

    if ( defined $response ) {

        if ( $response->status eq 'notfound' ) {

            $self->render( status => 404, text => $response->data);

        } elsif ( $response->status eq 'serve' ) {

            # TODO

        } elsif ( $response->status eq 'redirect' ) {

            $self->redirect_to( $response->data ) ;

        } elsif ( $response->status eq 'bytes'  )  {

            $self->render_data( $response->data ) ;

        } elsif ( $response->status  eq 'json') {

            $self->render_json( $response->data ) ;

        } elsif ( $response->status eq 'error' ) {

            $self->render( status => 501, text => $response->data ) ;

        } else {

            $self->render( status => 501, text => "Unknown error, no knowing state responded" );
        }


    } else {

            $self->render( status => 404, text => "Could not find response" );

    }

}

1;
