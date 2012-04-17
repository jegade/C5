package C5::Manage;

use strict;
use warnings;
use utf8;

use base 'Mojolicious::Controller';

sub list {

    my $self = shift;

    my $objects = [ sort { $a->{meta}{type} cmp $b->{meta}{type} }  $self->storage->repository->query()->all ];
    

    $self->stash( objects => $objects );

    $self->render( handler => 'tt' );

}

sub update {

    my $self = shift;

    my $uuid = $self->stash('uuid');

    my $o = $self->storage->repository->query(  { uuid =>  $uuid  } )->next;


    foreach my $key ( keys %{$o->{payload}} ) {
     
        my @values = $self->param("payload.".$key);
        $o->{payload}{$key} = ( @values > 1 ) ? [ grep {  $_ ne '' } @values ] : $values[0];
    }

    $self->storage->repository->storage->update( $o );

    $self->redirect_to( '/_manage/view/'.$uuid ) ;

}

sub drop {

    my  $self = shift;

    my $uuid = $self->stash('uuid');

    $self->storage->repository->storage->drop($uuid );

    $self->redirect_to( '/_manage/list' ) ;
}


sub create {

    my $self = shift;

    my $type = $self->stash('type');

    my $class =  "C5::Engine::".ucfirst $type;

    my $obj = $class->new(  repository => $self->storage->repository );

    $obj->store_to_repository;

    $self->redirect_to( '/_manage/view/'.$obj->uuid) ;

}

sub view {

    my $self = shift;

    my $object = $self->storage->repository->query( { uuid => $self->stash('uuid') } )->next;

    my $instances = [ $self->storage->repository->query( { 'meta.type' => 'instance' } )->all ];

    use Data::Printer; 
 

    p $instances;

    $self->stash( object => $object,instances => $instances );

  
    delete $object->{_id};

    my $dumped = p %$object;

    $self->stash(  dumped => $dumped );
    
    $self->render( handler => 'tt' );

}

1;
