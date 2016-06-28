package Markets::Event::Filter;
use Mojo::Base 'Markets::Event';

sub add_filter {
    my ( $ev, $name, $code, $arg ) = ( shift, shift, shift, shift // {} );
    $arg->{code} = $code;
    $arg->{priority} //= 100;
    $ev->on( $name => $arg );
    $ev->sort($name);
}

1;
