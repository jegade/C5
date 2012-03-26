package C5::Storage::Element;

use Moo;

has uuid        => ( is => 'rw' );
has title       => ( is => 'rw' );
has description => ( is => 'rw' );
has instance    => ( is => 'rw' );
has code        => ( is => 'rw' );
has type        => ( is => 'rw' );

sub get_element_by_uuid {

    my ( $self, $uuid ) = @_;

    return $self->_make_dummy_element($uuid);

}

sub make_dummy_element {

    my ( $self, $uuid ) = @_;

    return $self->new(

        uuid        => $uuid,
        title       => "HTML",
        description => "Einfaches Dummy-Element",
        code        => qq|   [% element.payload %]  <hr />     |,
        type        => 'html'

    );

}

1;

