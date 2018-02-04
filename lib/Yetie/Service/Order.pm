package Yetie::Service::Order;
use Mojo::Base 'Yetie::Service';

has resultset => sub { shift->schema->resultset('Sales::Order') };

sub find_order {
    my ( $self, $order_id ) = @_;

    my $result = $self->resultset->find_by_id($order_id);
    my $data = $result ? $result->to_data : {};

    my $order_detail = $self->factory('entity-order_detail')->create($data);
    return $order_detail;
}

1;
__END__

=head1 NAME

Yetie::Service::Order

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Service::Order> inherits all attributes from L<Yetie::Service> and implements
the following new ones.

=head1 METHODS

L<Yetie::Service::Order> inherits all methods from L<Yetie::Service> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
