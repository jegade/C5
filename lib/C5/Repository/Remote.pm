
package C5::Repository::Remote;

use Moo;

has base => ( is => 'rw' );
has remotes => ( is => 'rw' );

=head1 C5::Repository::Remote

    Handling Remote Actions

=cut


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

1;
