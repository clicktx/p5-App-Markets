package Markets::Session::Cart;
use Mojo::Base -base;
use Scalar::Util qw/weaken/;

has 'session';

sub data {
    my $self      = shift;
    my $cart_data = $self->session->data->{cart};

    # Getter
    return @_ ? $cart_data->{ $_[0] } : $cart_data if ( @_ < 2 and ref $_[0] ne 'HASH' );

    # Setter
    $self->session->_is_flushed(0);
    return @_ > 1 ? $cart_data->{ $_[0] } = $_[1] : $self->session->data( cart => $_[0] );
}

sub flash {
    my $self = shift;

    $self->session->_is_flushed(0);
    @_ ? delete $self->data->{ $_[0] } : $self->data( {} );
}

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new(@_);

    weaken $self->{session};
    return $self;
}

1;
__END__

=head1 NAME

Markets::Session::Cart

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

=head1 METHODS

=head2 C<data>

    # Get cart data
    $cart->data;                # All cart data
    $cart->data('items');

    # Set cart data
    $cart->data( \%cart_data ); # All cart data
    $cart->data( items => [] );

=head2 C<flash>

    # All data flash.
    $cart->flash;

    # Flash Instracted data.
    $cart->flash('items');

=head1 SEE ALSO

L<Markets::Session::ServerSession>

L<MojoX::Session>

L<Mojolicious>

=cut
