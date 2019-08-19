package Yetie::Domain::Value::Price;
use MooseX::Types::Common::Numeric qw/PositiveOrZeroNum/;
use Math::Currency;
use overload q{""} => sub { $_[0]->amount }, fallback => 1;

use Moose;
extends 'Yetie::Domain::Value';

has '+value' => (
    isa     => PositiveOrZeroNum,
    default => 0,
);

has currency_code => (
    is      => 'ro',
    default => 'USD',
);
has is_tax_included => (
    is      => 'ro',
    isa     => 'Bool',
    default => 0,
);

sub amount {
    my $self = shift;
    return Math::Currency->new( $self->value, $self->currency_code );
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::Value::Price

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Value::Price> inherits all attributes from L<Yetie::Domain::Value> and implements
the following new ones.

=head2 C<currency_code>

Default "USD"

=head2 C<value>

PositiveNum only.

=head2 C<is_tax_included>

Return boolean value.

=head1 METHODS

L<Yetie::Domain::Value::Price> inherits all methods from L<Yetie::Domain::Value> and implements
the following new ones.

=head2 C<amount>

Return L<Math::Currency> object.

=head1 OPERATOR

L<Yetie::Domain::Value::Price> overloads the following operators.

=head2 C<stringify>

    my $amount = "$price";

Alias for L</amount>.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Value>
