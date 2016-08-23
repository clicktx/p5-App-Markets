package Markets::Hook::Action;
use Mojo::Base 'Markets::Hook';

sub add_action {
    my ( $self, $name, $cb, $arg ) = ( shift, shift, shift, shift // {} );
    $arg->{cb} = $cb;
    $arg->{priority} //= 100;
    $self->on( $name => $arg );
    $self->sort($name);
    return $arg;
}

1;
