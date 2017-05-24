package Markets::Service::Cart;
use Mojo::Base 'Markets::Service';

sub add_item {
    my $self = shift;

    my $params = $self->controller->req->params->to_hash;
    delete $params->{csrf_token};

    my $item = $self->controller->factory('entity-item')->create($params);
    return $self->controller->cart->add_item($item);
}

sub create_entity {
    my $self = shift;

    my $cart_data = $self->controller->cart_session->data;
    $cart_data->{cart_id} = $self->controller->cart_session->cart_id;

    return $self->app->factory('entity-cart')->create($cart_data);
}

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

Return entity cart object.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO
