package C5::Storage::Content;

use Moo;

has uuid        => ( is => 'rw' );
has title       => ( is => 'rw' );
has description => ( is => 'rw' );
has instance    => ( is => 'rw' );
has path        => ( is => 'rw' );
has payload     => ( is => 'rw' );
has type        => ( is => 'rw' );

sub get_by_path {

    my ( $self, $instance, $path ) = @_;

    my $set = [];

    foreach my $count ( 1 .. 10 ) {
        push @$set, $self->make_dummy_content( $count, $instance, $path );
    }

    return $set;
}

sub make_dummy_content {

    my ( $self, $id, $instance, $path ) = @_;

    return $self->new(
        uuid     => 'content-' . $id,
        title    => "Sample content",
        payload  => "",
        type     => 'content',
        path     => $path,
        instance => $instance,
    );
}

1;

