package Markets::Service::Cart;
use Mojo::Base 'Markets::Service';

sub add_item {
    my ( $self, $item ) = @_;
    return if ref $item ne 'HASH';

    # TODO: [WIP]商品追加時はすべての商品を $items->[0] に保存すること
    my $items = $self->data('items');
    push @{ $items->[0] }, $item;

    return $self->data( items => $items );
}

sub data { shift->controller->cart_session->data(@_) }

sub items { $_[0]->model('cart')->items( $_[0]->data ) }

1;
__END__

=head1 NAME

Markets::Service::Cart

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Service::Cart> inherits all attributes from L<Markets::Service> and implements
the following new ones.

=head1 METHODS

=head2 C<add_item>

    $c->service('cart')->add_item( \%item );

=head2 C<data>

    my $data = $c->service('cart')->data;
    $c->service('cart')->data( fizz => buzz );

Alias for L<Markets::Session::CartSession/"data">.

=head2 C<items>

    my $items = $c->service('cart')->items;

Get cart items.
Return L<Mojo::Collection> object.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO
