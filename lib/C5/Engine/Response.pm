package C5::Engine::Response;

use Moo;

has status => ( 'is' => 'rw' ); 
has data   => ( 'is' => 'rw' );

1;
