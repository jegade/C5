package C5::Storage::Response;

use Moo;

has status => ( 'is' => 'rw' ); 
has data   => ( 'is' => 'rw' );

1;
