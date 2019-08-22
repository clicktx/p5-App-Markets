package Yetie::Domain::Entity::TaxRule;
use MooseX::Types::Common::Numeric qw/PositiveOrZeroNum/;
use Math::Currency;

use Moose;
use Moose::Util::TypeConstraints;
use namespace::autoclean;
extends 'Yetie::Domain::Entity';

enum RoundMode => [qw/even odd +inf -inf zero trunc/];

has tax_rate => (
    is      => 'ro',
    isa     => PositiveOrZeroNum,
    default => 0,
);
has title => (
    is  => 'ro',
    isa => 'Str',
);
has round_mode => (
    is      => 'ro',
    isa     => 'RoundMode',
    default => 'even',
);

sub caluculate_tax {
    my ( $self, $price ) = @_;

    my $currency_code = $price->currency_code;
    my $rate = $self->tax_rate ? $self->tax_rate / 100 : 0;
    return $price->is_tax_included
      ? Math::Currency->new( $price->amount / ( 1 + $rate ) * $rate, $currency_code )
      : Math::Currency->new( $price->amount * $rate, $currency_code );
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::Entity::TaxRule

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::TaxRule> inherits all attributes from L<Yetie::Domain::Entity> and L<Yetie::Domain::Role::Category>.

implements the following new ones.

=head2 C<tax_rate>

Tax rate.

    # 8%
    say Yetie::Domain::Entity::TaxRule->new( tax_rate => 8.000 )->tax_rate . '%';

=head2 C<title>

Tax rule title.

=head2 C<round_mode>

'even', 'odd', '+inf', '-inf', 'zero', 'trunc'

L<Math::BigFloat#Rounding>

=head1 METHODS

L<Yetie::Domain::Entity::TaxRule> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<caluculate_tax>

    my $amount = $tax_rule->caluculate_tax( Yetie::Domain::Value::Price->new(100) );
    my $amount = $tax_rule->caluculate_tax( Yetie::Domain::Value::Price->new( value => 100, is_tax_included => 1 ) );

Return L<Math::Currency> object.

See L<Yetie::Domain::Value::Price>

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>
