package Yetie::Service::Price;
use Mojo::Base 'Yetie::Service';
use Yetie::Util qw(args2hash);

sub create_new {
    my ( $self, @args ) = @_;
    my $option = args2hash(@args);

    my $value           = $option->{value}           || 0;
    my $currency_code   = $option->{currency_code}   || $self->pref('locale_currency_code');
    my $is_tax_included = $option->{is_tax_included} || $self->pref('is_price_including_tax');

    return $self->factory('value-price')->construct(
        value           => $value,
        currency_code   => $currency_code,
        is_tax_included => $is_tax_included,
    );
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

    my $price = $service->create_new;

    my $price = $service->create_new( %options || \%options );

=over

=item OPTIONS

B<value>

Decimal value. Default: 0

B<currency_code>

String value. Default: application preference C<locale_currency_code>

B<is_tax_included>

Boolean value. Default: application preference C<is_price_including_tax>

=back

Return L<Yetie::Domain::Value::Price> object.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
