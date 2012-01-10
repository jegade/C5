
package C5::Repository;

use strict;
use warnings;

use Data::UUID::MT;

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

    return;
}

=head2 get

    Get a single object

=cut

sub get {

    my ( $self, $uuid ) = @_;

    my ( $meta, $payload ) = $self->base->storage->get($uuid);
    return self->create( $meta, $payload );
}

sub get_raw {

    my ( $self, $uuid ) = @_;

    my ( $meta, $payload ) = $self->base->storage->get($uuid);
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

=head1 C5::Repository::Storage


=cut

package C5::Repository::Storage;

=head2 new

    Create an new Object

=cut

sub new {

    my ( $package, $base, $options ) = @_;
    $options->{base} = $base;
    return bless $options, $package;
}

=head2 db

=cut

sub db {

    my $self = shift;
    use MongoDB::OID;
    return $self->{db} ||= MongoDB::Connection->new( $self->{options}{db} );
}

=head2 base

=cut

sub base {

    my ($self) = @_;
    return $self->{base};
}

=head2 get

=cut

sub get {

    my ( $self, $uuid ) = @_;

    my $raw = $self->db->find_one( { uuid => $uuid } );

    if ($raw) {

        return ( $raw->{meta}, $raw->{payload} );

    } else {

        return;
    }

}

sub create {

    my ( $self, $meta, $payload ) = @_;

    return $self->db->insert();

}

=head2 list_uuids

=cut

sub list_uuids {

    my ($self) = @_;
    return [ map { [ $_->{uuid}, $_->{created} ] } $self->db->find( {}, { uuid => 1, created => 1 } )->all ];
}

=head2 list_uuids_older

=cut

sub list_uuids_older {

    my ( $self, $older ) = @_;
    return [ map { [ $_->{uuid}, $_->{created} ] } $self->db->find( { created => { '$lt' => $older } }, { uuid => 1, created => 1 } )->all ];
}

1;

=head1 C5::Repository::Object


=cut

package C5::Repository::Object;

=head2 new

    Create an new Object

=cut

sub new {

    my ( $package, $ref, $meta, $payload ) = @_;
    return bless { %$ref, meta => $meta, payload => $payload }, $package;
}

sub base {

    my ($self) = @_;
    return $self->{base};

}

=head2 update

=cut

sub update {

    my ( $self, $payload ) = @_;

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

1;

=head1 C5::Repository::Manage


=cut

package C5::Repository::Manage;

=head2 new 

=cut

sub new {

    my ( $self, $base, $options ) = @_;

    $options->{base} = $base;

    return bless $options, $self;
}

=head2 base

=cut

sub base {

    my ($self) = @_;
    return $self->{base};
}

=head2 rsync

    rsync every object to an remote system

=cut

sub rsync {

    my ( $self, $remote ) = @_;

    # Get every local object  [ [ uuid, epoch ], …  ]
    my $list = $self->base->storage->list_uuids;

    # Query remote for missing objects
    my $missings = $self->remote->check_for_updates($list);

    foreach my $uuid (@$missings) {
        my $obj = $self->base->get($uuid);
        $self->base->remote->update( $remote, $obj );
    }
}

=head2 purge 

    Purge old object from storage

=cut

sub purge {

    my ( $self, $older ) = @_;

    my $list = $self->base->storage->list_uuids_older($older);

    foreach my $uuid (@$list) {
        $self->base->storage->drop($uuid);
    }

    return $list;
}

1;

=head1 C5::Repository::Remote

    Handling Remote Actions

=cut

package C5::Repository::Remote;

=head2 new

=cut

sub new {

    my ( $self, $base, $config ) = @_;

    $config->{base} = $base;

    return bless $config, $self;
}

=head2 check_for_updates

=cut

sub check_for_updates {

    my ( $self, $list ) = @_;
}

=head2 update

=cut

sub update {

    my ( $self, $obj ) = @_;

    foreach my $remote ( $self->remotes ) {

    }

}

=head2 retrieve 

    Retrieve an remote package

=cut

sub retrieve {

    my ( $self, $cmd, $string ) = @_;

}

=head2 remotes

=cut

sub remotes {

    return { shift->{remotes} };
}

1;
