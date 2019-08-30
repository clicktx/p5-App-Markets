package Yetie::Domain::Value::Price;
use MooseX::Types::Common::Numeric qw/PositiveOrZeroNum/;
use Math::Currency;
use Carp qw(croak);

use Moose;
use overload
  '""'     => sub { $_[0]->amount },
  '+'      => \&add,
  '-'      => \&subtract,
  '*'      => \&multiply,
  fallback => 1;
extends 'Yetie::Domain::Value';

with 'Yetie::Domain::Role::TypesMoney';

has '+value' => (
    isa     => PositiveOrZeroNum,
    default => 0,
);
has currency_code => (
    is      => 'ro',
    isa     => 'CurrencyCode',
    default => 'USD',
);
has is_tax_included => (
    is      => 'ro',
    isa     => 'Bool',
    default => 0,
);
has round_mode => (
    is      => 'ro',
    isa     => 'RoundMode',
    default => 'even',
);

sub add {
    my $self = shift;
    my $num = shift || 0;

    $self->_validate_error($num);
    return $self->clone( value => $self->amount->copy->badd($num)->as_float );
}

sub amount {
    my $self = shift;

    my $mc = Math::Currency->new( $self->value, $self->currency_code );
    $mc->round_mode( $self->round_mode );
    return $mc;
}

sub multiply {
    my $self = shift;
    my $num = shift || 0;

    $self->_validate_error($num);
    return $self->clone( value => $self->amount->copy->bmul($num)->as_float );
}

sub subtract {
    my $self = shift;
    my $num = shift || 0;

    $self->_validate_error($num);
    return $self->clone( value => $self->amount->copy->bsub($num)->as_float );
}

sub to_data {
    my $self = shift;

    return {
        value           => $self->value,
        currency_code   => $self->currency_code,
        is_tax_included => $self->is_tax_included,
    };
}

sub _validate_error {
    my ( $self, $arg ) = @_;
    return if !ref $arg;

    croak 'unable to perform arithmetic on different currency types' if $self->currency_code ne $arg->currency_code;
    croak 'unable to perform arithmetic on different including tax'  if $self->is_tax_included != $arg->is_tax_included;
    return;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__
=for stopwords +inf -inf trunc

=head1 NAME

Yetie::Domain::Value::Price

=head1 SYNOPSIS

=head1 DESCRIPTION

    my $price = Yetie::Domain::Value::Price->new( value => 100, currency_code => 'USD', is_tax_included => 0 );

    # Overloading, returns new instance
    my $p2 = $price + 1;
    my $p3 = $price - 1;
    my $p4 = $price * 1;
    my $p5 = $price / 1;
    my $p5 = $price % 1;

    # Objects work too
    my $p7 = $p2 + $p3;
    my $p8 = $p2 - $p3;
    my $p8 = $p2 * $p3;
    my $p8 = $p2 / $p3;

    # Modifies in place
    $price += 1;
    $price -= 1;
    $price *= 1;
    $price /= 1;

=head1 ATTRIBUTES

L<Yetie::Domain::Value::Price> inherits all attributes from L<Yetie::Domain::Value> and implements
the following new ones.

=head2 C<currency_code>

Default "USD"

=head2 C<value>

PositiveNum only.

=head2 C<is_tax_included>

Return boolean value.

Default false.

=head2 C<round_mode>

'even', 'odd', '+inf', '-inf', 'zero', 'trunc'

L<Math::BigFloat#Rounding>

=head1 METHODS

L<Yetie::Domain::Value::Price> inherits all methods from L<Yetie::Domain::Value> and implements
the following new ones.

=head2 C<add>

    my $price2 = $price->add(1);
    my $price3 = $price->add($price);

=head2 C<amount>

Return L<Math::Currency> object.

=head2 C<subtract>

    my $price2 = $price->subtract(1);
    my $price3 = $price->subtract($price);

=head1 OPERATOR

L<Yetie::Domain::Value::Price> overloads the following operators.

Inspired by L<Data::Money>.

=head2 C<stringify>

    my $amount = "$price";

Alias for L</amount>.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Math::Currency>, L<Yetie::Domain::Value>
