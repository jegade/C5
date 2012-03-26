package C5::Storage::Tree;

use Moo;
use utf8;

has uuid        => ( is => 'rw' );
has name        => ( is => 'rw' );
has type        => ( is => 'rw' );    # content, media, assets
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

=head2 items 

    Build recursive structur

=cut

sub items {

    my ($self) = @_;

    my $root = [];

    my $by_path = {};

    foreach my $path ( @{ $self->paths } ) {

        $path->{children} = [];
        $by_path->{ $path->{sort} } = $path;
    }

    foreach my $item ( @{ $self->paths } ) {

        if ( defined $item->{parent} ) {
        
            if ( defined $by_path->{ $item->{parent} } ) { 
                push @{ $by_path->{ $item->{parent} }{children} }, $item;
            }

        } else {

            push @$root, $item;

        }
    }

    return $root;

}

=head2 nodes

=cut

sub nodes {

    my ($self) = @_;
    return [ map { C5::Storage::Node->new( %$_, path => $self->root . $_->{path}, theme => 'theme-01', type => 'html', content => 'plain' ) } @{ $self->paths } ];
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
            path        => "/site/startseite",
            description => "Die Startseite",
            parent      => undef,
            sort        => 1,
        },

        {
            name        => "Aktuelles",
            parent      => 1,
            path        => "/site/startseite/aktuelles",
            description => "Die News",
            sort        => 2,
        },

        {
            name        => "Impressum",
            path        => "/site/startseite/impressum",
            description => "Das Impressum",
            sort        => 3,
            parent      => 1,
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

    my $menu  = $self->new( uuid => 'menu',   name => "Menü",  root => "",      paths => $menu_tree );
    my $media = $self->new( uuid => 'mendia', name => 'Medien', root => '/media', paths => $media_tree );

    push $trees, $menu;
    push $trees, $media;

    return $trees;

}

1;
