package C5::Engine::Instance;

use Moo;
use Data::UUID::MT;

has uuid => ( is => 'rw', lazy => 1, default => sub { return Data::UUID::MT->new->create_string } );
has title       => ( is => 'rw' );
has description => ( is => 'rw' );
has authority   => ( is => 'rw', lazy => 1, default => sub { return [] } );
has trees       => ( is => 'rw' );
has paths       => ( is => 'rw' );
has elements    => ( is => 'rw' );
has themes      => ( is => 'rw' );
has areas       => ( is => 'rw' );
has repository  => ( is => 'rw' );

=head2 get_instances

    Query every instance 

=cut

sub get_instances {

    my ( $self, $repository ) = @_;

    my $instances = [];

    my @in = $repository->query( { 'meta.type' => 'instance' } )->all;

    foreach my $i (@in) {
        push @$instances, C5::Engine::Instance->new( repository => $repository, %{ $i->{payload} } );
    }

    return $instances;
}

=head2 get_node_by_path 
    
    get node for path

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

    get content for path

=cut

sub get_content_by_path {

    my ( $self, $path ) = @_;
    return C5::Engine::Content->get_by_path( $self->repository, $self->uuid, $path );
}

=head2 init

    Preload nodes, paths, themes and elements

=cut

sub init {

    my ($self) = @_;

    # Load every path from the given trees
    my $trees = C5::Engine::Tree->get_trees_by_instance( $self->repository, $self->uuid );

    my $set       = {};
    my $trees_set = {};

    foreach my $tree (@$trees) {

        my $nodes = $tree->nodes;
        $trees_set->{ $tree->accessor } = $tree;

        foreach my $node (@$nodes) {
            $set->{ $node->path } = $node;
        }

    }

    $self->trees($trees_set);
    $self->paths($set);

    # Load every element
    my $elements_by_uuid = C5::Engine::Element->elements_by_uuid( $self->repository, $self->uuid );
    $self->elements($elements_by_uuid);

    # Load every area
    my $areas_by_accessor = C5::Engine::Area->areas_by_accessor( $self->repository, $self->uuid );
    $self->areas($areas_by_accessor);

    # Preload themes
    my $themes = C5::Engine::Theme->get_themes_by_instance( $self->repository, $self->uuid );
    my $themes_by_uuid = {};
    foreach my $theme (@$themes) {
        $themes_by_uuid->{ $theme->uuid } = $theme;
    }
    $self->themes($themes_by_uuid);

}

=head2 store_to_repository

    Glue to the repository
    
=cut

sub store_to_repository {

    my ($self) = @_;

    my $meta = {

        uuid => $self->uuid,
        type => 'instance',
    };

    my $payload = {

        uuid        => $self->uuid,
        title       => $self->title,
        description => $self->description,
        authority   => $self->authority
    };

    my $obj = $self->repository->create( $meta, $payload );

    return $obj->save;

}

1;

