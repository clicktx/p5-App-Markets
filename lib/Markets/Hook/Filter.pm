package Markets::Hook::Filter;
use Mojo::Base 'Markets::Hook';

sub add_filter {
    my ( $self, $name, $code, $arg ) = ( shift, shift, shift, shift // {} );
    $arg->{cb} = $code;
    $arg->{priority} //= 100;
    $self->on( $name => $arg );
    $self->sort($name);
}

1;
