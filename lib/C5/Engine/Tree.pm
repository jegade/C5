package C5::Engine::Tree;

use Moo;

use Data::UUID::MT;
use utf8;

has uuid => ( is => 'rw', lazy => 1, default => sub { return Data::UUID::MT->new->create_string } );
has name => ( is => 'rw' );
has type        => ( is => 'rw' );    # content, media, assets
has description => ( is => 'rw' );
has authority   => ( is => 'rw' );
has paths       => ( is => 'rw' );
has instance    => ( is => 'rw' );
has root        => ( is => 'rw' );
has version     => ( is => 'rw' );
has state       => ( is => 'rw' );
has repository  => ( is => 'rw' );
has accessor    => ( is => 'rw' );

=head2 get_tree_by_instance

    Get the related trees for an instance

=cut

sub get_trees_by_instance {

    my ( $self, $repository, $instance ) = @_;

    my @in = $repository->query( { 'meta.type' => 'tree', 'payload.instance' => $instance } )->all;

    my $trees;

    foreach my $i (@in) {
        push @$trees, C5::Engine::Tree->new( repository => $repository, %{ $i->{payload} }, uuid => $i->{uuid} );
    }

    return $trees;

}

=head2 get_node_by_path 


=cut

sub get_node_by_path {

    my ( $self, $path ) = @_;

    my $paths = $self->paths;

}

=head2 items 

    Build recursive structur

=cut

sub items {

    my ($self) = @_;

    my $root = [];

    my $by_path = {};

    foreach my $path ( @{ $self->paths } ) {

        $path->{children} = [];
        $by_path->{ $path->{sort} } = $path;
    }

    foreach my $item ( @{ $self->paths } ) {

        if ( defined $item->{parent} ) {

            if ( defined $by_path->{ $item->{parent} } ) {
                push @{ $by_path->{ $item->{parent} }{children} }, $item;
            }

        } else {

            push @$root, $item;

        }
    }

    return $root;

}

=head2 nodes

=cut

sub nodes {

    my ($self) = @_;
    
    return [ map { C5::Engine::Node->new( %$_, path => $self->root . $_->{path}, theme => undef, type => 'html', content => 'plain' ) } @{ $self->paths } ];
}

=head2 store_to_repository

=cut

sub store_to_repository {

    my ($self) = @_;

    my $meta = {

        uuid => $self->uuid,
        type => 'tree',
    };

    my $payload = {

        uuid        => $self->uuid,
        name        => $self->name,
        root        => $self->root,
        paths       => $self->paths,
        description => $self->description,
        authority   => $self->authority,
        instance    => $self->instance,
        accessor    => $self->accessor,
    };

    my $obj = $self->repository->create( $meta, $payload );

    return $obj->save;

}

1;
