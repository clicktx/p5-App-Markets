package Yetie::Domain::Entity::TaxRule;
use MooseX::Types::Common::Numeric qw/PositiveOrZeroNum PositiveInt/;
use Math::Currency;

use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::Entity';

with 'Yetie::Domain::Role::TypesMoney';

has _round_mode => (
    is       => 'ro',
    isa      => 'RoundMode',
    reader   => 'round_mode',
    init_arg => 'round_mode',
);
has '+id' => (
    isa      => PositiveInt,
    required => 1,
);
has tax_rate => (
    is      => 'ro',
    isa     => PositiveOrZeroNum,
    default => 0,
);
has title => (
    is  => 'ro',
    isa => 'Str',
);

sub caluculate_tax {
    my ( $self, $price ) = @_;

    my $attrs = $price->to_data;
    $attrs->{round_mode} = $self->round_mode if $self->round_mode;

    my $tax_base = $self->factory('value-tax')->construct($attrs);
    my $rate = $self->tax_rate ? $self->tax_rate / 100 : 0;
    my $tax =
        $price->is_tax_included
      ? $tax_base / ( 1 + $rate ) * $rate
      : $tax_base * $rate;

    return $tax;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__
=for stopwords +inf -inf trunc

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

=head1 METHODS

L<Yetie::Domain::Entity::TaxRule> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<caluculate_tax>

    my $tax_amount = $tax_rule->caluculate_tax( Yetie::Domain::Value::Price->new(100) );
    my $tax_amount = $tax_rule->caluculate_tax( Yetie::Domain::Value::Price->new( value => 100, is_tax_included => 1 ) );

Arguments L<Yetie::Domain::Value::Price> object.

Return L<Yetie::Domain::Value::Price> object.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>
