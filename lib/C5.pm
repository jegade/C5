package C5;
use Mojo::Base 'Mojolicious';

use DateTime;
use C5::Repository;

# This method will run once at server start
sub startup {

    my $self = shift;

    $self->sessions->default_expiration(86400);

    # Default-Locale
    DateTime->DefaultLocale('de-DE');

    # Secret passphrase
    $self->secret('e469204d87f8b2a74190e42ddd821059039d40ef');

    $self->attr( repo => sub { C5::Repository->new( $self->defaults->{config}{repository} ) } );

# Database connection $self->storage->db->name
    $self->helper( repository => sub { shift->app->repo } );

    # Routes
    my $r = $self->routes;

    my $root = $r->bridge('/')->to('root#auth');

    $root->route('/')->to('root#index');

    $root->route('/(*path)')->to('frontend#view');

}

1;
