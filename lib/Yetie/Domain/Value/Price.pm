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
  '/'      => \&divide,
  '%'      => \&modulo,
  '>'      => \&greater_than,
  '<'      => \&less_than,
  '>='     => \&not_less,
  '<='     => \&not_greater,
  '=='     => \&equals,
  '!='     => \&not_equals,
  fallback => 1;
extends 'Yetie::Domain::Value';

with 'Yetie::Domain::Role::TypesMoney';

has _price_id => (
    is       => 'ro',
    default  => undef,
    init_arg => 'id',
    reader   => 'price_id',
);
has _round_mode => (
    is       => 'ro',
    isa      => 'RoundMode',
    reader   => 'round_mode',
    init_arg => 'round_mode',
);
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

override to_data => sub {
    my $self = shift;

    return {
        id              => $self->price_id,
        value           => $self->value,
        currency_code   => $self->currency_code,
        is_tax_included => $self->is_tax_included,
    };
};

sub add {
    my $self = shift;
    my $num = shift || 0;

    $self->_validate($num);
    return $self->clone( value => $self->amount->copy->badd($num)->as_float );
}

sub amount {
    my $self = shift;

    my $mc = Math::Currency->new( $self->value, $self->currency_code );
    $mc->round_mode( $self->round_mode ) if $self->round_mode;
    return $mc;
}

sub divide {
    my $self = shift;
    my $num = shift || 0;

    $self->_validate($num);
    return $self->clone( value => $self->amount->copy->bdiv($num)->as_float );
}

sub equals {
    my $self = shift;
    my $num = shift || 0;

    $self->_validate($num);
    return $self->amount->beq($num);
}

sub greater_than {
    my $self = shift;
    my $num = shift || 0;

    $self->_validate($num);
    return $self->amount->bgt($num);
}

sub less_than {
    my $self = shift;
    my $num = shift || 0;

    $self->_validate($num);
    return $self->amount->blt($num);
}

sub modulo {
    my $self = shift;
    my $num = shift || 0;

    $self->_validate($num);
    return $self->clone( value => $self->amount->copy->bmod($num)->as_float );
}

sub multiply {
    my $self = shift;
    my $num = shift || 0;

    $self->_validate($num);
    return $self->clone( value => $self->amount->copy->bmul($num)->as_float );
}

sub not_equals {
    my $self = shift;
    my $num = shift || 0;

    $self->_validate($num);
    return $self->amount->bne($num);
}

sub not_greater {
    my $self = shift;
    my $num = shift || 0;

    $self->_validate($num);
    return $self->amount->ble($num);
}

sub not_less {
    my $self = shift;
    my $num = shift || 0;

    $self->_validate($num);
    return $self->amount->bge($num);
}

sub subtract {
    my $self = shift;
    my $num = shift || 0;

    $self->_validate($num);
    return $self->clone( value => $self->amount->copy->bsub($num)->as_float );
}

sub _validate {
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

    # Compares against numbers
    $price > 10;
    $price < 10;
    $price >= 10;
    $price <= 10;

    # and objects
    my $bool = $price > $price2;
    my $bool = $price < $price2;
    my $bool = $price >= $price2;
    my $bool = $price <= $price2;

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

=head2 C<price_id>

Init argument C<id>

Default undef

=head2 C<round_mode>

'even', 'odd', '+inf', '-inf', 'zero', 'trunc'

L<Math::BigFloat#Rounding>

=head1 METHODS

L<Yetie::Domain::Value::Price> inherits all methods from L<Yetie::Domain::Value> and implements
the following new ones.

=head2 C<add>

    # $price + 1
    my $price2 = $price->add(1);

    # $price + $price
    my $price3 = $price->add($price);

=head2 C<amount>

Return L<Math::Currency> object.

=head2 C<divide>

    # $price / 1
    my $price2 = $price->divide(1);

    # $price / $price
    my $price3 = $price->divide($price);

=head2 C<equals>

    # $price == 1
    my $bool = $price->equals(1);

    # $price == $price2
    my $bool = $price->equals($price2);

=head2 C<greater_than>

    # $price > 1
    my $bool = $price->greater_than(1);

    # $price > $price2
    my $bool = $price->greater_than($price2);

=head2 C<less_than>

    # $price < 1
    my $bool = $price->less_than(1);

    # $price < $price2
    my $bool = $price->less_than($price2);

=head2 C<modulo>

    # $price % 1
    my $price2 = $price->modulo(1);

    # $price % $price
    my $price3 = $price->modulo($price);

=head2 C<multiply>

    # $price * 1
    my $price2 = $price->multiply(1);

    # $price * $price
    my $price3 = $price->multiply($price);

=head2 C<not_equals>

    # $price != 1
    my $bool = $price->not_equals(1);

    # $price != $price2
    my $bool = $price->not_equals($price2);

=head2 C<not_greater>

    # $price <= 1
    my $bool = $price->not_greater(1);

    # $price <= $price2
    my $bool = $price->not_greater($price2);

=head2 C<not_less>

    # $price >= 1
    my $bool = $price->not_less(1);

    # $price >= $price2
    my $bool = $price->not_less($price2);

=head2 C<subtract>

    # $price - 1
    my $price2 = $price->subtract(1);

    # $price - $price
    my $price3 = $price->subtract($price);

=head1 OPERATOR

L<Yetie::Domain::Value::Price> overloads the following operators.

Inspired by L<Data::Money>.

=head2 C<stringify>

    my $amount = "$price";

Alias for L</amount>.

=head2 C<+>

=head2 C<->

=head2 C<*>

=head2 C</id>

=head2 C<%>

=head2 C<+=>

=head2 C<-=>

=head2 C<*=>

=head2 C</=>

=head2 C<%=>

=head2 C<==>

=head2 C<!=>

=head2 C<E<gt>>

=head2 C<E<lt>>

=head2 C<E<gt>=>

=head2 C<E<lt>=>

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Math::Currency>, L<Yetie::Domain::Value>
