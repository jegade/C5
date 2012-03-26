
package C5::Repository::Storage;

use Moo;

use Data::Printer;

has base => ( is => 'rw' );
has collection => ( is => 'rw', lazy => 1, default => sub { return 'c5' }  );
has connection => ( is => 'rw', lazy => 1, default => sub { return {} } ) ;

=head2 db

=cut

sub db {

    my $self = shift;
    my $collection = $self->collection;
    return $self->{db} ||= MongoDB::Connection->new( %{ $self->connection } )->$collection->objects;
}


=head2 query

=cut

sub query {

    my ( $self, @args ) = @_;
    $self->db->query( @args ) ;
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

sub update {

    my ( $self, $raw ) = @_;

    p $raw;

    $self->db->update( { uuid => $raw->{uuid} }, $raw, { upsert => 1, safe => 1 } );
    $self->journal( 'update',  $raw->{uuid} );    
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


sub journal {

    my ( $self, $action, $uuid ) = @_;
    printf STDERR ( "%s %s\n", $action, $uuid);
}


1;

