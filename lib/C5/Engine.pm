#!perl

package C5::Engine;

use C5::Engine::Instance;
use C5::Engine::Theme;
use C5::Engine::Content;
use C5::Engine::Tree;
use C5::Engine::Element;
use C5::Engine::Node;
use C5::Engine::Response;
use C5::Engine::Area;
use Encode;

use Moo;

has instances  => ( is => 'rw' );
has cache      => ( is => 'rw' );
has repository => ( is => 'rw' );

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

    my ($self) = @_;

    # Get instances
    my $instances = C5::Engine::Instance->get_instances( $self->repository );

    my $set = {};

    foreach my $instance (@$instances) {

        # Initialisiere Instance, preload, themes, paths and elements
        $instance->init;

        my $authorities = ref $instance->authority eq 'ARRAY' ? $instance->authority : [ $instance->authority ];
        
        foreach my $authority ( @{ $authorities } ) {
            $set->{$authority} = $instance;
        }
    }

    $self->instances($set);

}

=head2 get_response_for

    Create an response for the given authority and path

=cut

sub get_response_for {

    my ( $self, $authority, $uri, $path ) = @_;

    # Search authority for request path
    if ( exists $self->instances->{$authority} ) {

        # TODO Upgrade Cache to something better
        if ( 0 &&  $self->cache && exists $self->cache->{$authority}{$path} ) {

            return $self->cache->{$authority}{$path};

        } else {

            # Get cached instance
            my $instance = $self->instances->{$authority};

            # Get the related node 
            my $node = $instance->get_node_by_path($path);

            my $type = "tt";

            # Get content for type
            my $content = $instance->get_content_by_path( $node->path, $type );

            my $response = undef;

            if ( defined $node ) {

                if ( $type eq 'code' ) {

                    # Code verarbeiten und Rückgabe
                    $response = C5::Engine::Response->new( $node->run );

                } elsif ( $type eq 'redirect' ) {

                    $response = C5::Engine::Response->new( status => 'redirect', data => $node->url );

                } elsif ( $type eq 'tt' ) {

                    $response = C5::Engine::Response->new( status => 'bytes', data => $self->wrap_with_theme( $instance, $node, $content ) );

                } elsif ( $type eq 'file' ) {

                    $response = C5::Engine::Response->new( status => 'serve', data => $node->fs );

                } elsif ( $type eq 'rss' || $type eq 'xml' ) {

                    $response = C5::Engine::Response->new( status => 'bytes', data => $self->build_feed( $instance, $node, $content ) );

                } else {

                    $response = C5::Engine::Response->new( status => 'notfound', data => 'Unkown Response type' );

                }

            } else {


                $response = C5::Engine::Response->new( status => 'notfound', data => "No node for $path found in ". $instance->title );
            }

            # Caching for code and html
            if ( 0  ) {

                # TODO build storage api
                if ( !$self->cache ) { $self->cache( {} ); }
                $self->cache->{$authority}{$path} = $response;
            }

            return $response;

        }

    } else {

        return C5::Engine::Response->new( status => 'notfound', data => 'Could not found instance for authority' );

    }

}

=head2 wrap_with_theme

    Use the TT based Theme an wrap the content 

=cut

sub wrap_with_theme {

    my ( $self, $instance, $node, $content ) = @_;

    use Template;

    my $tt = Template->new( { UNICODE => 1 } ) || die "$Template::ERROR\n";

    my $theme = undef;

    # Suche Theme oder nehme Default
    if ( defined $node->theme ) {
    
        $theme = $instance->themes->{ $node->theme };

    } else {

        my $themes = $instance->themes;
        my @set =  values %{ $themes } ;
        $theme = $set[0];
    }

    die "Missing theme" unless defined $theme;

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

    return encode( 'utf-8', $output );
}

1;
