
package C5::Repository::Remote;

use strict;
use warnings;

=head1 C5::Repository::Remote

    Handling Remote Actions

=cut


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
