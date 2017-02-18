package Markets::Cart;
use Mojo::Base -base;

use Scalar::Util qw/weaken/;
use Mojo::Collection qw/c/;

has 'cart_session';

sub add_item {
    my ( $self, $item ) = @_;
    return if ref $item ne 'HASH';

    my $items = $self->data('items');
    push @{ $items->[0] }, $item;

    return $self->data( items => $items );
}

sub data { shift->cart_session->data(@_) }

sub items {
    my $self = shift;

    my $items = $self->data('items') || [ [] ];
    return c(@$items);
}

sub new {
    my ( $class, $c ) = @_;
    my $self = $class->SUPER::new( cart_session => $c->cart_session );

    weaken $self->{cart_session};
    return $self;
}

1;
__END__

=head1 NAME

Markets::Cart

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Cart> inherits all attributes from L<Mojo::Base> and implements
the following new ones.

=head1 METHODS

=head2 C<add_item>

    $cart->add_item( \%item );

=head2 C<data>

    my $data = $cart->data;
    $cart->data( fizz => buzz );

Alias for L<Markets::Session::CartSession/"data">.

=head2 C<items>

    my $items = $cart->items;

Return L<Mojo::Collection> object.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO
