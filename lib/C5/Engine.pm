#!perl

package C5::Engine;

use C5::Engine::Instance;
use C5::Engine::Theme;
use C5::Engine::Content;
use C5::Engine::Tree;
use C5::Engine::Element;
use C5::Engine::Node;
use C5::Engine::Response;
use Encode;

use Moo;

has instances => ( is => 'rw' );
has cache     => ( is => 'rw' ) ;


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
    my $instances = C5::Engine::Instance->get_instances;

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
        
        # TODO Upgrade Cache to something better
        if ( $self->cache && exists $self->cache->{ $authority }{ $path } ) {

            
            return $self->cache->{ $authority }{ $path } ;

        } else {

            my $instance = $self->instances->{$authority} ;

            my $node = $instance->get_node_by_path( $path ) ;

            my $response = undef;
                
            if ( defined $node ) {

                if ( $node->type eq 'code'  ) {

                    # Code verarbeiten und Rückgabe
                    $response = C5::Engine::Response->new( $node->run ) ;

                } elsif ( $node->type eq 'redirect' ) {
    
                    $response = C5::Engine::Response->new( status => 'redirect', data => $node->url ) ;
                

                } elsif ( $node->type eq 'html' ) {
                                   
                    $response = C5::Engine::Response->new( status => 'bytes', data => $self->wrap_with_theme($instance, $node)   );

                } elsif ( $node->type eq 'file' ) {

                    $response = C5::Engine::Response->new( status => 'serve', data => $node->fs );

                } else {

                    $response = C5::Engine::Response->new( status => 'notfound', data => 'Unkown Response type' );

                }

            } else {

                $response = C5::Engine::Response->new( status => 'notfound', data => "No node found" );
            }

            # Caching for code and html
            if ( $node->type eq 'html' || $node->type eq 'code' ) {

                # TODO build storage api
                if ( !$self->cache) {  $self->cache({} ); }
                $self->cache->{$authority}{$path} = $response;
            }
        
            return $response;


        }
    
    } else {

        return C5::Engine::Response->new( status => 'notfound', data => 'Could not found instance for authority' );

    }

    
}

=head2 wrap_with_theme

=cut

sub wrap_with_theme {

    my ( $self, $instance, $node ) = @_;

    use Template;

    my $tt = Template->new({ UNICODE => 1 }) || die "$Template::ERROR\n";
    
    # Suche Theme oder nehme Default
    my $theme = $instance->themes->{$node->theme};
    $theme = shift values  $instance->themes unless $theme;

    # Get content
    my $content = $instance->get_content_by_path( $node->path ) ; 

    die "Missing theme" unless $theme;

    my $code = $theme->code;

    my $stash = {
        node     => $node,
        elements => $instance->elements,
        trees    => $instance->trees,
        instance => $instance, 
        theme    => $theme,
        content  => $content
    };

    # Process Theme
    my $output = "";
    $tt->process( \$code, $stash, \$output ) or die $tt->error;

    return encode('utf-8', $output );
}




1;
