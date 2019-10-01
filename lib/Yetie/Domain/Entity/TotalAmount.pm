package Yetie::Domain::Entity::TotalAmount;
use Carp qw(croak);

use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::Entity';

has tax_rate => (
    is      => 'ro',
    default => 0,
);
has tax => (
    is      => 'ro',
    isa     => 'Yetie::Domain::Value::Tax',
    default => sub { shift->factory('value-tax')->construct() },
);
has total_excl_tax => (
    is      => 'ro',
    isa     => 'Yetie::Domain::Value::Price',
    default => sub { shift->factory('value-price')->construct() },
);
has total_incl_tax => (
    is      => 'ro',
    isa     => 'Yetie::Domain::Value::Price',
    default => sub { shift->factory('value-price')->construct( is_tax_included => 1 ) },
);

sub sum {
    my ( $self, $item ) = @_;
    croak 'Tax rate is different.' if $self->tax_rate != $item->tax_rate;

    return $self->new(
        tax_rate       => $self->tax_rate,
        tax            => $self->tax + $item->tax_amount,
        total_excl_tax => $self->total_excl_tax + $item->row_total_excl_tax,
        total_incl_tax => $self->total_incl_tax + $item->row_total_incl_tax,
    );
}

sub tax_rate_percentage {
    my $self = shift;

    my $rate += $self->tax_rate;
    return $rate . q{%};
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::Entity::TotalAmount

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::TotalAmount> inherits all attributes from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<tax_rate>

=head2 C<tax>

L<Yetie::Domain::Value::Tax> object.

=head2 C<total_excl_tax>

L<Yetie::Domain::Value::Price> object.

=head2 C<total_incl_tax>

L<Yetie::Domain::Value::Price> object.

=head1 METHODS

L<Yetie::Domain::Entity::TotalAmount> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<sum>

    my $new = $total->sum($line_item);

Arguments L<Yetie::Domain::Entity::LineItem> object.

Return L<Yetie::Domain::Entity::TotalAmount> object.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>
