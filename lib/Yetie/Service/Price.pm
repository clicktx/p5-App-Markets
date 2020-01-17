package Yetie::Service::Price;
use Mojo::Base 'Yetie::Service';

sub create_new {
    my ( $self, $value ) = ( shift, shift // 0 );

    my $attrs = {
        value           => $value,
        currency_code   => $self->pref('locale_currency_code'),
        is_tax_included => $self->pref('is_price_including_tax'),
    };
    return $self->factory('value-price')->construct($attrs);
}

1;
__END__

=head1 NAME

Yetie::Service::Price

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Service::Price> inherits all attributes from L<Yetie::Service> and implements
the following new ones.

=head1 METHODS

L<Yetie::Service::Price> inherits all methods from L<Yetie::Service> and implements
the following new ones.

=head2 C<create_new>

    my $price = $service->create_new($value);

Return L<Yetie::Domain::Value::Price> object.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
