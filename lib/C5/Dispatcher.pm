package C5::Dispatcher;

use strict;
use warnings;
use utf8;

use base 'Mojolicious::Controller';

use Data::Printer;

use C5::Storage::Instance;
use C5::Storage::Theme;
use C5::Storage::Content;
use C5::Storage::Tree;
use C5::Storage::Element;


sub view {

    my $self = shift;

    my $path = $self->stash('path');
    $path = "/".$path if index($path,"/") != 0;

    my $authority = $self->req->url->to_abs->authority;

    # Search the related instance for the domain:port
    my $instance = C5::Storage::Instance->get_instance_by_authority($authority);

    if ( defined $instance ) {

        # Initialise Instance
        $instance->init;

        # Search the related node
        my $node = $instance->get_node_by_path($path);
        


        if ( defined $node ) {

            # Get the content for the path
            my $content = $instance->get_content_by_path( $node->path );

            # Get Element 
            my $elements = $instance->elements;

            my $theme = C5::Storage::Theme->_make_basis_theme;

            # Stashing something
            $self->stash( 'instance'  => $instance );
            $self->stash( 'theme'     => $theme );
            $self->stash( 'authority' => $authority );
            $self->stash( 'content'   => $content );
            $self->stash( 'node'      => $node );
            $self->stash( 'trees'     => $instance->trees );
            $self->stash( 'elements'  => $elements );

        } else {

            $self->render( status => 404, text => "Could not found node for $path" );


        }

    } else {

            $self->render( status => 404, text => "Could not find instance for $authority" );

    }

}

1;
