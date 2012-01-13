

use strict;
use warnings;

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


