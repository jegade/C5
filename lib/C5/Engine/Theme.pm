package C5::Engine::Theme;

use Moo;
use utf8;

extends 'C5::Engine';

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

            margin-left: 30%;
        }

        #sidebar {

            width: 25%;
            float: left;  
        }
    </style>

</head>

<body>
    <div id="sidebar">

            <ul>
                
                [% FOREACH item IN trees.menu.items %]

                    <li><a href="[% item.path %]">[% item.name | html %]</a>
                    
                    [% IF item.children.size > 0 %]
                    <ul>
                        [% FOREACH child IN item.children %]
                        
                            <li><a href="[% child.path %]">[% child.name | html %]</a></li>
                     
                        [% END %]
                    </ul>
                    [% END %]

                    </li>


                    

                [% END %]

            </ul>



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

=head2 get_themes_by_instance 


=cut

sub get_themes_by_instance {

    my ( $self ) = @_;

    my $themes = [];
    push @$themes, $self->_make_basis_theme;
    return $themes;
}


=head2 _make_basis_theme 


=cut

sub _make_basis_theme {

    my ( $self ) = @_;
    return $self->new(  uuid =>  'theme-01', title =>  'Plain Theme', description => 'a very basis plain theme' );
}

1;

