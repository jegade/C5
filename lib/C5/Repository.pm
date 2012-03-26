
package C5::Repository;

use strict;
use warnings;

use Moo;

use Data::UUID::MT;

use MongoDB;
use MongoDB::OID;

use C5::Repository::Remote;
use C5::Repository::Storage;
use C5::Repository::Manage;
use C5::Repository::Object;

has remote  => ( is => 'rw' );
has storage => ( is => 'rw' );
has manage  => ( is => 'rw' );

has ug => ( is => 'rw', lazy => 1, default => sub { return Data::UUID::MT->new } );


sub init { 

    my ( $self ) = @_;

    $self->remote( C5::Repository::Remote->new( base => $self ) );
    $self->storage( C5::Repository::Storage->new( base => $self ) );
    $self->manage( C5::Repository::Manage->new( base => $self ) );

};

=head2 create

=cut

sub create {

    my ( $self, $meta, $payload ) = @_;

    $meta->{uuid}   ||= $self->ug->create_string;
    $meta->{type}   ||= "base";
    $meta->{create} ||= time();

    my $obj = C5::Repository::Object->new( base => $self, meta => $meta, payload => $payload );
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

1;
