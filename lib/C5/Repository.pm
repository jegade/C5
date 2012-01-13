
package C5::Repository;

use strict;
use warnings;

use Data::UUID::MT;

use MongoDB;
use MongoDB::OID;

use C5::Repository::Remote;
use C5::Repository::Storage;
use C5::Repository::Manage;
use C5::Repository::Object;

sub new {

    my ( $self, $options ) = @_;

    my $base = bless {}, $self;

    $base->{remote} = C5::Repository::Remote->new( $base, $options );
    $base->{storage} = C5::Repository::Storage->new( $base, $options );
    $base->{manage} = C5::Repository::Manage->new( $base, $options );

    $base->{ug} = Data::UUID::MT->new;

    return $base;
}

=head2 create


=cut

sub create {

    my ( $self, $meta, $payload ) = @_;

    $meta->{uuid}   ||= $self->{ug}->create_string;
    $meta->{type}   ||= "base";
    $meta->{create} ||= time();

    my $obj = C5::Repository::Object->new( $self, $meta, $payload );

    return $obj;
}

=head2 get

    Get a single object

=cut

sub get {

    my ( $self, $uuid ) = @_;

    my ( $meta, $payload ) = $self->storage->get($uuid);
    return $self->create( $meta, $payload );
}

sub get_raw {

    my ( $self, $uuid ) = @_;

    my ( $meta, $payload ) = $self->storage->get($uuid);
}

=head2 query

    Query a set of objects

=cut

sub query {

    my ( $self, $query ) = @_;

    return $self->storage->query($query);
}

sub query_raw {

    my ( $self, $query ) = @_;

    return $self->storage->query($query);
}

sub storage {

    shift->{storage};
}

sub remote {

    shift->{remote};
}

sub manage {

    shift->{manage};
}

1;
