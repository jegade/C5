package C5::Storage::Theme;

use Moo;
use utf8;


has uuid        => ( is => 'rw' );
has title       => ( is => 'rw' );
has description => ( is => 'rw' );
has instance    => ( is => 'rw' );
has code        => (
    is      => 'rw',
    lazy    => 1,
    default => sub {
        return qq~<!DOCTYPE html>
        <html>
        <head>
            <title>[% instance.title %] with some german umlaut äöü …</title>

            <style>
                
                #main {

                    margin-right: 30%;
                }

                #sidebar {
    
                    width: 25%;
                    float: right;  
                }
            </style>

        </head>
        
        <body>
           <div id="sidebar">

                 [% FOREACH element IN content.sidebar %]

                    [% element.process | eval  %]

                [% END %]
    
            </div>

            <div id="main">

                [% FOREACH element IN content.main %]

                    [% element.process | eval  %]

                [% END %]
            </div>

         
            <p>Some extra chars ✈ ☢ </p>


        </body>
        
        </html>~;
    }
);


=head2 _make_basis_theme 


=cut

sub _make_basis_theme {

    my ( $self ) = @_;
    return $self->new(  uuid =>  'theme-01', title =>  'Plain Theme', description => 'a very basis plain theme' );
}

1;
