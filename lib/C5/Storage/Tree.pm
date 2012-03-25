package C5::Storage::Tree;

use Moo;

has name        => ( is => 'rw' );
has uuid        => ( is => 'rw' );
has type        => ( is => 'rw' );
has description => ( is => 'rw' );
has authority   => ( is => 'rw' );
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

    my $paths = $self->paths;


}

=head2 nodes

=cut

sub nodes {
    
    my ( $self ) = @_;
    return [ map { C5::Storage::Tree::Node->new( %$_, path => $self->root. $_->{path} ) } @{$self->paths} ];
}

=head2 _dummy_trees

    Build a bunch dummy trees
    
=cut

sub _dummy_trees {

    my ($self) = @_;

    my $trees = [];

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
            path        => "/",
            description => "Alle",
        },

        {
            name        => "Fotos",
            path        => "/photo",
            description => "Die Fotos",
        },

        {
            name        => "Vidos",
            path        => "video",
            description => "Die Videos",
        },
    ];

    my $menu  = $self->new( uuid => 'menu-01',   name => "Menü",   root => "/site",  paths => $menu_tree );
    my $media = $self->new( uuid => 'mendia-01', name => 'Medien', root => '/media', paths => $media_tree );

    
    push $trees, $menu;
    push $trees, $media;

    return $trees;

}


package  C5::Storage::Tree::Node;

use Moo;

has name          => ( is => 'rw' );
has path         => ( is => 'rw' );
has descrioption => ( is => 'rw' );
has theme        =>  ( is => 'rw' );
1
;
