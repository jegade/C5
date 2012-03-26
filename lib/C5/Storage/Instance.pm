package C5::Storage::Instance;

use Moo;

has uuid        => ( is => 'rw' );
has title       => ( is => 'rw' );
has description => ( is => 'rw' );
has authority   => ( is => 'rw' );
has trees       => ( is => 'rw' );
has paths       => ( is => 'rw' );
has elements    => ( is => 'rw' );
has themes      => ( is => 'rw' );

=head2 get_instance_by_authority

    Get the related instance for the given authority

=cut

sub get_instance_by_authority {

    my ( $self, $authority ) = @_;

    # TODO, Dummy so far

    return $self->_dummy_instance("default");
}

sub get_instances {

    my ($self) = @_;

    my $instances = [];

    foreach ( 1..50 ) {
        push @$instances,  $self->_dummy_instance("dev.nacworld.net:8011");
        push @$instances,  $self->_dummy_instance("dev.nacworld.net:8010");
     }

    return $instances;
}

=head2 get_node_by_path 

=cut

sub get_node_by_path {

    my ( $self, $path ) = @_;

    if ( exists $self->paths->{$path} ) {

        return $self->paths->{$path};

    } else {

        return;
    }

}

=head2 get_content_by_path 

=cut

sub get_content_by_path {

    my ( $self, $path ) = @_;
    return C5::Storage::Content->get_by_path( $self->uuid, $path );
}

=head2 init

    Preload 

=cut

sub init {

    my ($self) = @_;

    # Load every path from the given trees
    my $trees = C5::Storage::Tree->get_trees_by_instance( $self->uuid );

    my $set = {};
    my $trees_set = {} ;

    foreach my $tree (@$trees) {

        my $nodes = $tree->nodes;

        $trees_set->{$tree->uuid} = $tree;

        foreach my $node (@$nodes) {

            $set->{ $node->path } = $node;
        }

    }

    $self->trees( $trees_set );
    $self->paths($set);

    # Load every element

    my $elements_by_uuid = {};

    foreach my $uuid ( ('element-h1', 'element-p','element-01' )) {
        my $element  = C5::Storage::Element->make_dummy_element( $uuid);
        $elements_by_uuid->{ $element->uuid } = $element;
    }

    $self->elements($elements_by_uuid);


    # Preload themes
    my $themes = C5::Storage::Theme->get_themes_by_instance( $self->uuid );

    my $themes_by_uuid = {};

    foreach my $theme ( @$themes ) {
        $themes_by_uuid->{$theme->uuid} = $theme;    
    }

    $self->themes( $themes_by_uuid ) ;
    
}

=head2 _dummy_instance

    Build an dummy
    
=cut

sub _dummy_instance {
    my ( $self, $authority ) = @_;
    return $self->new( uuid => 'instance-01', authority => [$authority], title => "Beispiel Instanz", description => "Das ist nur eine Beispiel Instanz des neuen CMS5" );

}

1;

