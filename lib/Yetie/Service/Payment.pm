package Yetie::Service::Payment;
use Mojo::Base 'Yetie::Service';

sub get_payment_methods {
    my $self = shift;

    my $list = $self->resultset('PaymentMethod')->search()->to_data;
    return $self->factory('list-payment_methods')->construct( list => $list );
}

1;

__END__

=head1 NAME

Yetie::Service::Payment

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Service::Payment> inherits all attributes from L<Yetie::Service> and implements
the following new ones.

=head1 METHODS

L<Yetie::Service::Payment> inherits all methods from L<Yetie::Service> and implements
the following new ones.

=head2 C<get_payment_methods>

    my $payment_methods = $service->get_list();

Return L<Yetie::Domain::List::PaymentMethods> object.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
