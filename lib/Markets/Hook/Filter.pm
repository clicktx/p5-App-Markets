package Markets::Hook::Filter;
use Mojo::Base 'Markets::Hook';

sub add_filter {
    my ( $self, $name, $cb, $arg ) = ( shift, shift, shift, shift // {} );
    $arg->{cb} = $cb;
    $arg->{priority} //= 100;
    $self->on( $name => $arg );
    $self->sort($name);
}

1;
