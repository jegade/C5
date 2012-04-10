package C5::Engine::Content;

use Moo;
use Data::UUID::MT;
use utf8;

has uuid => ( is => 'rw', lazy => 1, default => sub { return Data::UUID::MT->new->create_string } );
has title       => ( is => 'rw' );
has description => ( is => 'rw' );
has instance    => ( is => 'rw' );
has path        => ( is => 'rw' );
has payload     => ( is => 'rw' );
has type        => ( is => 'rw' );
has element     => ( is => 'rw' );
has area        => ( is => 'rw' );
has repository  => ( is => 'rw' );

=head2 store_to_repository

=cut

sub store_to_repository {

    my ($self) = @_;

    my $meta = {

        uuid => $self->uuid,
        type => 'content',
    };

    my $payload = {

        uuid        => $self->uuid,
        title       => $self->title,
        description => $self->description,
        instance    => $self->instance,
        path        => $self->path,
        payload     => $self->payload,
        type        => $self->type,
        element     => $self->element,
        area        => $self->area,

    };

    my $obj = $self->repository->create( $meta, $payload );

    return $obj->save;

}

=head2 get_by_path

    Search content by path

=cut

sub get_by_path {

    my ( $self, $repository, $instance, $path ) = @_;

    my @in = $repository->query( { 'meta.type' => 'content', 'payload.path' => $path, 'payload.instance' => $instance } )->all;

    my $content;

    foreach my $i (@in) {
        my $c = C5::Engine::Content->new( repository => $repository, %{ $i->{payload} }, uuid => $i->{uuid} );
        push @{ $content->{ $c->area } }, $c;
    }

    return $content;

}

=head2 process
    
    Process TT2 with eval
    
    
=cut

sub process {

    my ($self) = @_;
    return sprintf( '[%% elements.${"%s"}.code | eval %%]', $self->element );
}

1;

