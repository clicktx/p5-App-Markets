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

    my $rate = $self->tax_rate ? $self->tax_rate / 100 : 0;
    my $tax =
        $price->is_tax_included
      ? $price->amount / ( 1 + $rate ) * $rate
      : $price->amount * $rate;

    my $mc = Math::Currency->new;
    $mc->round_mode( $self->round_mode );
    return $mc->new( $tax, $price->currency_code );
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

    my $tax_amount = $tax_rule->caluculate_tax( Yetie::Domain::Value::Price->new(100) );
    my $tax_amount = $tax_rule->caluculate_tax( Yetie::Domain::Value::Price->new( value => 100, is_tax_included => 1 ) );

Arguments L<Yetie::Domain::Value::Price> object.

Return L<Math::Currency> object.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>
