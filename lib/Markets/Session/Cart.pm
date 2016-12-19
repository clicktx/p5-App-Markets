package Markets::Session::Cart;
use Mojo::Base -base;

sub data {
    my $self = shift;
    return $self->{_data}->{cart} = $_[0] if ref $_[0] eq 'HASH';

    my $data = $self->{_data}->{cart};
    return @_ ? @_ > 1 ? $data->{ $_[0] } = $_[1] : $data->{ $_[0] } : $data;
}

sub flash {
    my $self = shift;

    return @_ ? delete $self->data->{ $_[0] } : $self->data( {} );
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

L<Markets::Session>

L<MojoX::Session>

L<Mojolicious>

=cut
