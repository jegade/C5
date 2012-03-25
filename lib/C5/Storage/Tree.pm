package C5::Storage::Tree;

use Moo;

has name        => ( is => 'rw' );
has uuid        => ( is => 'rw' );
has type        => ( is => 'rw' );
has description => ( is => 'rw' );
has domain      => ( is => 'rw' );
has paths       => ( is => 'rw' );
has instance    => ( is => 'rw' );
has root        => ( is => 'rw' );
has version     => ( is => 'rw' ); 
has state       => ( is => 'rw' );

=head2 get_tree_by_instance

    Get the related trees for an instance

=cut

sub get_trees_by_instance {

    my ( $self, $instance ) = @_;

    # TODO
    my $trees = $self->_dummy_trees;
    return $trees;
}

=head2 get_node_by_path 


=cut

sub get_node_by_path {

    my ( $self, $path ) = @_;

}

=head2 _dummy_trees

    Build a bunch dummy trees
    
=cut

sub _dummy_trees {

    my ($self) = @_;

    my $trees = {};

    my $menu_tree = [

        {
            name        => "Startseite",
            path        => "/startseite",
            description => "Die Startseite",
        },


        {
            name        => "Aktuelles",
            path        => "/startseite/aktuelles",
            description => "Die News",
        },

        {
            name        => "Impressum",
            path        => "/startseite/impressum",
            description => "Das Impressum",
        },

    ];

    my $media_tree = [

        {
            name        => "Medien",
            path        => "/media",
            description => "Alle",
        },


        {
            name        => "Fotos",
            path        => "/media/photo",
            description => "Die Fotos",
        },

        {
            name        => "Vidos",
            path        => "/media/video",
            description => "Die Videos",
        },
    ];

    my $menu  = $self->new( uuid => 'menu-01', name => "Menü",     root => "/", paths => $menu_tree );
    my $media = $self->new( uuid => 'mendia-01', name => 'Medien', root => '/media', paths => $media_tree );

    $trees->{by_root}{ $menu->root }  = $menu;
    $trees->{by_root}{ $media->root } = $media;

    $trees->{by_uuid}{ $menu->uuid }  = $menu;
    $trees->{by_uuid}{ $media->uuid } = $media;

    return $trees;

}


1;
