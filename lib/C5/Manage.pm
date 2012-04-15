package C5::Manage;

use strict;
use warnings;
use utf8;

use base 'Mojolicious::Controller';

sub list {

    my $self = shift;

    my $objects = [ $self->storage->repository->query()->all ];

    use Data::Printer;

    p $objects;

    $self->stash( objects => $objects );

    $self->render( handler => 'tt' );

}

sub update {

    my $self = shift;

    my $uuid = $self->stash('uuid');

    my $object = $self->storage->repository->query( { uuid => $uuid } )->next;

    $self->redirect_to( '/_manage/view/'.$uuid ) ;

}

sub view {

    my $self = shift;

    my $object = $self->storage->repository->query( { uuid => $self->stash('uuid') } )->next;

    $self->stash( object => $object );

    use Data::Printer; 
   
    delete $object->{_id};

    my $dumped = p %$object;

    $self->stash(  dumped => $dumped );
    
    $self->render( handler => 'tt' );

}

1;
