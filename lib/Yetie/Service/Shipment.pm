package Yetie::Service::Shipment;
use Mojo::Base 'Yetie::Service';

sub get_shipping_fee {
    # my ( $self, $sales_order ) = @_;

    # 送料テーブルから取得
    # $self->resultset('ShippingRate')
    return 30;
}

1;
__END__

=head1 NAME

Yetie::Service::Shipment

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Service::Shipment> inherits all attributes from L<Yetie::Service> and implements
the following new ones.

=head1 METHODS

L<Yetie::Service::Shipment> inherits all methods from L<Yetie::Service> and implements
the following new ones.

=head2 C<get_shipping_fee>

    my $shipping_fee = $service->get_shipping_fee($sales_order);

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
