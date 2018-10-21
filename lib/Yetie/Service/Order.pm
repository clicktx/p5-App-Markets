package Yetie::Service::Order;
use Mojo::Base 'Yetie::Service::Base';

sub find_order {
    my ( $self, $order_id ) = @_;

    my $result = $self->resultset('Sales::Order')->find_by_id($order_id);
    my $data = $result ? $result->to_data : {};

    # Set address type
    do { $data->{$_}->{type} = $_ if $data->{$_} }
      for qw(billing_address shipping_address);

    my $order_detail = $self->factory('entity-order_detail')->construct($data);
    return $order_detail;
}

1;
__END__

=head1 NAME

Yetie::Service::Order

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Service::Order> inherits all attributes from L<Yetie::Service::Base> and implements
the following new ones.

=head1 METHODS

L<Yetie::Service::Order> inherits all methods from L<Yetie::Service::Base> and implements
the following new ones.

=head2 C<find_order>

    my $order_detail = $servece->find_order($order_id);

Return L<Yetie::Domain::Entity::OrderDetail> object.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service::Base>
