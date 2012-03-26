package C5::Storage::Content;

use Moo;
use utf8;

extends 'C5::Storage';

has title       => ( is => 'rw' );
has description => ( is => 'rw' );
has instance    => ( is => 'rw' );
has path        => ( is => 'rw' );
has payload     => ( is => 'rw' );
has type        => ( is => 'rw' );
has element     => ( is => 'rw' );
has area        => ( is => 'rw' );

sub get_by_path {

    my ( $self, $instance, $path ) = @_;

    my $set = {};

    $set->{main}[0] = $self->make_dummy_content(1, $instance,  $path, 'main' );
    $set->{main}[1] = $self->make_dummy_content(2, $instance,  $path, 'main' );
    $set->{main}[2] = $self->make_dummy_content(3, $instance,  $path, 'main' );
     
    $set->{sidebar}[0] = $self->make_dummy_content(1, $instance,  $path, 'sidebar' );
    $set->{sidebar}[1] = $self->make_dummy_content(2, $instance,  $path, 'sidebar' );
    $set->{sidebar}[2] = $self->make_dummy_content(3, $instance,  $path, 'sidebar' );
 
    return $set;
}

sub make_dummy_content {

    my ( $self, $id, $instance, $path, $area ) = @_;

    return $self->new(
        uuid     => 'content-' . $id,
        title    => "Sample content",
        payload  => "Sample Content in payload $id",
        type     => 'content',
        path     => $path,
        instance => $instance,
        element  => 'element-01',
        area     => $area,
    );
}

=head2 process

    

=cut

sub process {

    my ( $self ) = @_;
    return sprintf('[%% elements.${"%s"}.code | eval %%]', $self->element);
}

1;

