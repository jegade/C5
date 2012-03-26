package C5;
use Mojo::Base 'Mojolicious';

use DateTime;
use C5::Repository;
use C5::Engine;

# This method will run once at server start
sub startup {

    my $self = shift;

    $self->sessions->default_expiration(86400);

    # Default-Locale
    DateTime->DefaultLocale('de-DE');

    # Secret passphrase
    $self->secret('e469204d87f8b2a74190e42ddd821059039d40ef');

    $self->attr( storage => sub { my $c5s = C5::Engine->new; $c5s->init; return $c5s;  } );

    # Database connection $self->storage->db->name
    $self->helper( storage => sub { shift->app->storage } );
    
    # Routes
    my $r = $self->routes;

    my $root = $r->bridge('/')->to('root#auth');

    $root->route('/')->to('dispatcher#view');

    $root->route('/(*path)')->to('dispatcher#view');

}

1;
