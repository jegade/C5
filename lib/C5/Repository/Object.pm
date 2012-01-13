

use strict;
use warnings;

package C5::Repository::Object;

=head2 new

    Create an new Object

=cut

sub new {

    my ( $package, $base, $meta, $payload ) = @_;
    return bless { base => $base, meta => $meta, payload => $payload }, $package;
}

sub base {

    my ($self) = @_;
    return $self->{base};

}

=head2 update

=cut

sub update {

    my ( $self, $payload ) = @_;

    $self->{payload} = $payload;

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

        uuid    => $self->{meta}{uuid},
        meta    => $self->{meta},
        payload => $self->{payload},
    };

    $self->base->storage->update($raw);
}

1;

