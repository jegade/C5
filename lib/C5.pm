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

    $self->attr(

        engine => sub {

            # Initialise Repository
            my $c5r = C5::Repository->new( options => $self->defaults->{config}{repository} );
            $c5r->init;

            # Initialise Engine
            my $c5e = C5::Engine->new( repository => $c5r, options => $self->defaults->{config}{engine} );
            $c5e->init;

            return $c5e;

          }

    );

    $self->plugin(
        tt_renderer => {
            template_options => {

                WRAPPER  => 'framework/wrapper',
                UNICODE  => 1,
                ENCODING => 'UTF-8',

            }
        }
    );


    # Database connection $self->storage->db->name
    $self->helper( engine => sub { shift->app->engine } );

    # Routes
    my $r = $self->routes;

    my $root = $r->bridge('/')->to('root#auth');

    $root->route('/')->to('dispatcher#view');

    $root->route('/_manage/list')->to('manage#list');
    $root->route('/_manage/create/#type')->to('manage#create');
    $root->route('/_manage/drop/#uuid')->to('manage#drop');
    $root->route('/_manage/view/#uuid')->to('manage#view');
    $root->route('/_manage/update/#uuid')->to('manage#update');


    $root->route('/(*path)')->to('dispatcher#view');

}

1;
