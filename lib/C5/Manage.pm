package C5::Manage;

use strict;
use warnings;
use utf8;

use Data::Printer;

use base 'Mojolicious::Controller';

sub list {

    my $self = shift;

    my $objects = [ sort { $a->{meta}{type} cmp $b->{meta}{type} } $self->engine->repository->query()->all ];

    $self->stash( objects => $objects );

    $self->render( handler => 'tt' );

}

sub update {

    my $self = shift;

    my $uuid = $self->stash('uuid');

    my $o = $self->engine->repository->query( { uuid => $uuid } )->next;


    foreach my $key ( keys %{ $o->{payload} } ) {

        my @values = $self->param( "payload." . $key );
        $o->{payload}{$key} = ( @values > 1 ) ? [ grep { $_ ne '' } @values ] : $values[0];
    }

    $self->engine->repository->storage->update($o);

    $self->redirect_to( '/_manage/view/' . $uuid );

}

sub drop {

    my $self = shift;

    my $uuid = $self->stash('uuid');

    $self->engine->repository->storage->drop($uuid);

    $self->redirect_to('/_manage/list');
}

sub create {

    my $self = shift;

    my $type = $self->stash('type');

    my $class = "C5::Engine::" . ucfirst $type;

    my $obj = $class->new( repository => $self->engine->repository );

    $obj->store_to_repository;

    $self->redirect_to( '/_manage/view/' . $obj->uuid );

}

sub view {

    my $self = shift;

    my $object = $self->engine->repository->query( { uuid => $self->stash('uuid') } )->next;
    
    my $instances = [ $self->engine->repository->query( { 'meta.type' => 'instance' } )->all ];
    my $areas     = [ $self->engine->repository->query( { 'meta.type' => 'area' } )->all ];
    my $elements  = [ $self->engine->repository->query( { 'meta.type' => 'element' } )->all ];

    my $types   = [qw/tt rss file/];

    $self->stash( object => $object, instances => $instances, areas => $areas, elements => $elements, types => $types );

    delete $object->{_id};

    my $dumped = p %$object;

    $self->stash( dumped => $dumped );
    $self->render( handler => 'tt' );

}

1;
