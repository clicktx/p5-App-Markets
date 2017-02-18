package Markets::Session::CartSession;
use Mojo::Base -base;
use Scalar::Util qw/weaken/;

has 'session';

sub cart_id { shift->session->cart_id(@_) }

# public用カートデータ
# $session->{cart}->{data}
sub data {
    my $self = shift;
    my $data = $self->_data('data');

    # Getter
    return @_ ? $data->{ $_[0] } : $data if ( @_ < 2 and ref $_[0] ne 'HASH' );

    # Setter
    $self->_is_modified(1);
    return @_ > 1 ? $data->{ $_[0] } = $_[1] : $self->_data( data => $_[0] );
}

sub flash {
    my $self = shift;

    $self->session->_is_flushed(0);
    @_ ? delete $self->data->{ $_[0] } : $self->data( {} );
}

sub new {
    my ( $class, $session ) = @_;
    my $arg = $session->data('cart');
    my $self = $class->SUPER::new( session => $session, %$arg );

    weaken $self->{session};
    return $self;
}

# 全てのcartデータ
# $session->{cart}
sub _data {
    my $self = shift;
    my $data = $self->session->data('cart');

    # Getter
    return @_ ? $data->{ $_[0] } : $data if ( @_ < 2 and ref $_[0] ne 'HASH' );

    # Setter
    $self->_is_modified(1);
    return @_ > 1 ? $data->{ $_[0] } = $_[1] : $self->session->data( cart => $_[0] );
}

sub _is_modified {
    my ( $self, $val ) = @_;

    if ( defined $val ) {
        $self->session->data('cart')->{_is_modified} = 1;
        $self->session->_is_flushed(0);
    }
    return $self->data('_is_modified');
}

1;
__END__

=head1 NAME

Markets::Session::CartSession

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

=head2 C<session>

Return L<Markets::Session::ServerSession> object.

=head1 METHODS

=head2 C<cart_id>

    my $id = $cart->cart_id;
    $cart->cart_id('xxxxxxxxxx');

Get/Set cart id. SEE L<Markets::Session::ServerSession>

=head2 C<data>

    # Get cart data
    $cart->data;                # All cart data
    $cart->data('items');

    # Set cart data
    $cart->data( \%cart_data ); # All cart data
    $cart->data( items => [] );

Get/Set cart data.

=head2 C<flash>

    # All data flash.
    $cart->flash;

    # Flash Instracted data.
    $cart->flash('items');

Remove cart data.

=head1 SEE ALSO

L<Markets::Session::ServerSession>

L<MojoX::Session>

L<Mojolicious>

=cut
