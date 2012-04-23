package C5::Engine::Area;

use Moo;
use Data::UUID::MT;
use utf8;

has uuid => ( is => 'rw', lazy => 1, default => sub { return Data::UUID::MT->new->create_string } );

has title       => ( is => 'rw' );  # title
has description => ( is => 'rw' );  # Description
has instance    => ( is => 'rw' );  # related instance
has type        => ( is => 'rw' );  # single, multiple
has possible    => ( is => 'rw' );  # Possible Elements
has accessor    => ( is => 'rw' );  # Name of the accesor/reference for the theme and content
has repository  => ( is => 'rw' );


=head2 store_to_repository

=cut

sub store_to_repository {

    my ($self) = @_;

    my $meta = {

        uuid => $self->uuid,
        type => 'area',
    };

    my $payload = {

        uuid        => $self->uuid,
        title       => $self->title,
        description => $self->description,
        instance    => $self->instance,
        type        => $self->type,
        possible    => $self->possible,
        accessor    => $self->accessor,
        
    };

    my $obj = $self->repository->create( $meta, $payload );

    return $obj->save;

}


sub areas_by_accessor {

    my ( $self, $repository, $instance ) = @_;
   
    my @in = $repository->query( { 'meta.type' => 'area', 'payload.instance' => $instance } )->all;

    my $areas;

    foreach my $i (@in) {
        my $e = C5::Engine::Area->new( repository => $repository, %{ $i->{payload} }, uuid => $i->{uuid} );
        if ( $e->accessor ) {
        
            $areas->{ $e->accessor } = $e;

        }
    }

    return $areas;
}

1;

