package C5::Engine::Element;

use Moo;
use Data::UUID::MT;
use utf8;

has uuid => ( is => 'rw', lazy => 1, default => sub { return Data::UUID::MT->new->create_string } );

has title       => ( is => 'rw' );
has description => ( is => 'rw' );
has instance    => ( is => 'rw' );
has code        => ( is => 'rw' );
has type        => ( is => 'rw' );
has repository  => ( is => 'rw' );

=head2 store_to_repository

=cut

sub store_to_repository {

    my ($self) = @_;

    my $meta = {

        uuid => $self->uuid,
        type => 'element',
    };

    my $payload = {

        title       => $self->title,
        uuid        => $self->uuid,
        description => $self->description,
        instance    => $self->instance,
        code        => $self->code,
        type        => $self->type,
    };

    my $obj = $self->repository->create( $meta, $payload );

    return $obj->save;

}

sub elements_by_uuid {

    my ( $self, $repository, $instance ) = @_;

    my @in = $repository->query( { 'meta.type' => 'element', 'payload.instance' => $instance } )->all;

    my $elements;

    foreach my $i (@in) {
        my $e = C5::Engine::Element->new( repository => $repository, %{ $i->{payload} }, uuid => $i->{uuid} );
        $elements->{ $e->uuid } = $e;
    }

    return $elements;
}

1;

