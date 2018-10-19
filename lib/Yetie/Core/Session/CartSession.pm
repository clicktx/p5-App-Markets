package Yetie::Core::Session::CartSession;
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
    $self->is_modified(1);
    return @_ > 1 ? $data->{ $_[0] } = $_[1] : $self->_data( data => $_[0] );
}

sub flash {
    my $self = shift;

    $self->session->_is_flushed(0);
    @_ ? delete $self->data->{ $_[0] } : $self->data( {} );
}

sub is_modified {
    my $self = shift;

    # Getter
    return $self->session->data('cart')->{_is_modified} ? 1 : 0 unless @_;

    # Setter
    my $val = shift;
    if ($val) {
        $self->session->data('cart')->{_is_modified} = 1;
        $self->session->_is_flushed(0);
    }
    else {
        $self->session->data('cart')->{_is_modified} = 0;
    }
}

sub new {
    my ( $class, $session ) = @_;
    my $self = $class->SUPER::new( session => $session );

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
    $self->is_modified(1);
    return @_ > 1 ? $data->{ $_[0] } = $_[1] : $self->session->data( cart => $_[0] );
}

1;
__END__

=head1 NAME

Yetie::Core::Session::CartSession

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

=head2 C<session>

Return L<Yetie::Core::Session::ServerSession> object.

=head1 METHODS

=head2 C<cart_id>

    my $id = $cart->cart_id;
    $cart->cart_id('xxxxxxxxxx');

Get/Set cart id. SEE L<Yetie::Core::Session::ServerSession>

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

=head2 C<is_modified>

    # Getter
    $cart->is_modified;

    # Setter
    $cart->is_modified(0);
    $cart->is_modified(1);

Get/Set modified flag.

=head1 SEE ALSO

L<Yetie::Core::Session::ServerSession>

L<MojoX::Session>

L<Mojolicious>

=cut
