package Markets::Hook::Filter;
use Mojo::Base 'Markets::Hook';

sub add_filter {
    my ( $ev, $name, $code, $arg ) = ( shift, shift, shift, shift // {} );
    $arg->{cb} = $code;
    $arg->{priority} //= 100;
    $ev->on( $name => $arg );
    $ev->sort($name);
}

1;
