#!perl 

use strict;
use warnings;
use utf8;

use FindBin qw($Bin);
use lib "$Bin/../lib";

use C5::Engine;
use C5::Engine::Instance;
use C5::Engine::Tree;
use C5::Engine::Theme;
use C5::Repository;

my $repository = C5::Repository->new();
$repository->init;

$repository->storage->db->drop;

my $instance = C5::Engine::Instance->new( repository => $repository, title => "First instance", description => "Some example instance", authority => [ '127.0.0.1:8010', '127.0.0.1:8011' ] );

$instance->store_to_repository();

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

my $tree_main = C5::Engine::Tree->new( repository => $repository, instance => $instance->uuid, accessor => 'menu', name => "Menü", root => "", paths => $menu_tree );
$tree_main->store_to_repository();

my $tree_media = C5::Engine::Tree->new( repository => $repository, instance => $instance->uuid, accessor => 'media', name => 'Medien', root => '/media', paths => $media_tree );
$tree_media->store_to_repository();

my $themes = C5::Engine::Theme->new( repository => $repository, instance => $instance->uuid, title => "Theme", description => "Example" );
$themes->store_to_repository();

my $element1 = C5::Engine::Element->new(

    repository  => $repository,
    instance    => $instance->uuid,
    title       => "HTML",
    description => "Einfaches Dummy-Element",
    code        => qq~ <h1>  [% element.payload %] [% element.title | html %] </h1>     ~,
    type        => 'html'

);

$element1->store_to_repository;

my $element2 = C5::Engine::Element->new(

    repository  => $repository,
    instance    => $instance->uuid,
    title       => "HTML",
    description => "Einfaches Dummy-Element",
    code        => qq~  <p> [% element.payload %] [% element.title | html %]</p>   ~,
    type        => 'html'

);

$element2->store_to_repository;

my $element3 = C5::Engine::Element->new(

    repository  => $repository,
    instance    => $instance->uuid,
    title       => "HTML",
    description => "Einfaches Dummy-Element",
    code        => qq~ <pre>[% element.payload %] [% element.title | html %]  </pre>     ~,
    type        => 'html'

);

$element3->store_to_repository;

my $content = C5::Engine::Content->new(

    repository => $repository,
    title      => "Sample content Startseite",
    payload    => "Sample Content in payload",
    type       => 'content',
    path       => "/site/startseite",
    instance   => $instance->uuid,
    element    => $element1->uuid,
    area       => "main",

);

$content->store_to_repository();

my $content = C5::Engine::Content->new(

    repository => $repository,
    title      => "Sample content Startseite",
    payload    => "Sample Content in payload",
    type       => 'content',
    path       => "/site/startseite",
    instance   => $instance->uuid,
    element    => $element2->uuid,
    area       => "main",

);

$content->store_to_repository();

my $content = C5::Engine::Content->new(

    repository => $repository,
    title      => "Sample content Startseite",
    payload    => "Sample Content in payload",
    type       => 'content',
    path       => "/site/startseite",
    instance   => $instance->uuid,
    element    => $element3->uuid,
    area       => "main",

);

$content->store_to_repository();

