package C5::Storage::Theme;

use Moo;

has uuid        => ( is => 'rw' );
has title       => ( is => 'rw' );
has description => ( is => 'rw' );
has instance    => ( is => 'rw' );
has code        => (
    is      => 'rw',
    lazy    => 1,
    default => sub {
        return qq|<!DOCTYPE html>
        <html>
        <head>
            <title>[% instance.title %]</title>
        </head>
        
        <body>
            [% content %]
        </body>
        
        </html>|;
    }
);


=head2 _make_basis_theme 


=cut

sub _make_basis_theme {

    my ( $self ) = @_;
    return $self->new(  uuid =>  'theme-01', title =>  'Plain Theme', description => 'a very basis plain theme' );
}

1;

