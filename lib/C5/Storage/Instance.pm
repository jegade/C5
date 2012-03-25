package C5::Storage::Instance;

use Moo;

extends 'C5::Storage';

has uuid        => ( is => 'rw' );
has title       => ( is => 'rw' );
has description => ( is => 'rw' );
has authority   => ( is => 'rw' );
has trees       => ( is => 'rw' );
has paths       => ( is => 'rw' );

=head2 get_instance_by_authority

    Get the related instance for the given authority

=cut

sub get_instance_by_authority {

    my ( $self, $authority ) = @_;

    # TODO, Dummy so far

    return $self->_dummy_instance("default");
}

=head2 get_node_by_path 

=cut

sub get_node_by_path {

    my ( $self, $path ) = @_;

    warn "Search for  path";

    if ( exists $self->paths->{$path}  ) {

        return $self->paths->{$path} ;
        
    } else {

        return;
    }

}

sub get_content_by_path {

    my ( $self, $path ) = @_;
    return C5::Storage::Content->get_by_path( $self->uuid, $path);
}


sub init {

    my ( $self ) = @_;

    # Load every path
    
    my $trees = C5::Storage::Tree->get_trees_by_instance( $self->uuid ); 

    my $set = {};

    foreach my $tree ( @$trees ) {

        my $nodes = $tree->nodes;

        foreach my $node ( @$nodes ) {

            $set->{$node->path} = $node;
        }

    }

    $self->paths( $set ) ;
}


=head2 _dummy_instance

    Build an dummy
    
=cut

sub _dummy_instance {
    my ( $self, $authority ) = @_;
    return $self->new( uuid => 'instance-01', authority => $authority, title => "Beispiel Instanz", description => "Das ist nur eine Beispiel Instanz des neuen CMS5" );

}

1;

