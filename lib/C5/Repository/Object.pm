
package C5::Repository::Object;

use Moo;

has base    => ( is => 'rw' );
has meta    => ( is => 'rw' );
has payload => ( is => 'rw' );

sub update {

    my ( $self, $payload ) = @_;

    $self->payload($payload);

    return;
}

=head2 propagate 

=cut

sub propagate {

    my ($self) = @_;

}

=head2 distribute 

=cut

sub distribute {

    my ($self) = @_;

}

sub save {

    my ($self) = @_;

    my $raw = {

        uuid    => $self->meta->{uuid},
        meta    => $self->meta,
        payload => $self->payload,
    };

    $self->base->storage->update($raw);
}

1;

