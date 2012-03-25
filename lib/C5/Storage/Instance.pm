package C5::Storage::Instance;
 
use Moo;

has title => (

    is => 'rw'

);

has description => ( 

    is => 'rw'

);

has domain => (
    
    is => 'rw'

);


=head2 get_instance_by_domain

    Get the related instance for the given domain

=cut

sub get_instance_by_domain {

    my ( $self, $domain ) = @_;

    # TODO, Dummy so far

    return $self->_dummy_instance;
}



=head2 _dummy_instance

    Build an dummy
    
=cut

sub _dummy_instance {
    my ( $self, $domain ) = @_;
    return $self->new( domain => $domain, title => "Beispiel Instanz" , description => "Das ist nur eine Beispiel Instanz des neuen CMS5");

}

1;


