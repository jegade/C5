#!perl

package C5::Storage;

use C5::Storage::Instance;
use C5::Storage::Theme;
use C5::Storage::Content;
use C5::Storage::Tree;
use C5::Storage::Element;
use C5::Storage::Node;
use C5::Storage::Response;

use Moo;

has instances => ( is => 'rw' );

=head2 store_to_repository

    Serialize and save into the repository

=cut

sub store_to_repository {

    my ($self) = @_;

}

=head2 init 

    Preload instance, themes, trees and elements

=cut

sub init {

    my ( $self ) = @_;

    # Get instances
    my $instances = C5::Storage::Instance->get_instances;

    my $set = {};

    foreach my $instance ( @$instances) {

        # Initialisiere Instance, preload, themes, paths and elements
        $instance->init;

        foreach my $authority ( @{$instance->authority} ) {
            $set->{$authority} = $instance;
        }
    }

    $self->instances( $set ) ;

}

=head2 get_response_for

    Create an response for the given authority and path

=cut

sub get_response_for {

    my ( $self, $authority, $path ) = @_;

    if ( exists $self->instances->{$authority} )  {

        my $instance = $self->instances->{$authority} ;

        my $node = $instance->get_node_by_path( $path ) ;

        if ( defined $node ) {

            if ( $node->type eq 'code'  ) {

                # Code verarbeiten und Rückgabe
                return C5::Storage::Response->new( $node->run ) ;

            } elsif ( $node->type eq 'redirect' ) {

                return C5::Storage::Response->new( status => 'redirect', data => $node->url ) ;
                

            } elsif ( $node->type eq 'html' ) {
                
                return C5::Storage::Response->new( status => 'bytes', data => $node->content . " … "  );
    
            } elsif ( $node->type eq 'file' ) {

                return C5::Storage::Response->new( status => 'serve', data => $node->fs );

            } else {

                return C5::Storage::Response->new( status => 'notfound', data => 'Unkown Response type' );

            }

        } else {

            return C5::Storage::Response->new( status => 'notfound', data => "No node found" );

        }

    
    } else {

        return C5::Storage::Response->new( status => 'notfound', data => 'Could not found instance for authority' );

    }

    
}




1;
