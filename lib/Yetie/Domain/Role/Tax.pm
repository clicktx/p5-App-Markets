package Yetie::Domain::Role::Tax;
use Moose::Role;
use Yetie::Factory;

has tax_rule => (
    is      => 'ro',
    isa     => 'Yetie::Domain::Entity::TaxRule',
    default => sub { Yetie::Factory->new('entity-tax_rule')->construct() },
);

sub price_excl_tax {
    my ( $self, %args ) = @_;

    my $attr = $args{attr} || 'price';
    return $self->$attr->is_tax_included
      ? $self->$attr->clone( is_tax_included => 0 ) - $self->tax_amount
      : $self->$attr;
}

sub price_incl_tax {
    my ( $self, %args ) = @_;

    my $attr = $args{attr} || 'price';
    return $self->$attr->is_tax_included
      ? $self->$attr
      : $self->$attr->clone( is_tax_included => 1 ) + $self->tax_amount->clone( is_tax_included => 1 );
}

sub tax_amount {
    my $self = shift;

    my $tax_amount = $self->tax_rule->caluculate_tax( $self->price );
    return $tax_amount;
}

sub tax_rate { return shift->tax_rule->tax_rate }

1;
__END__

=head1 NAME

Yetie::Domain::Role::Tax

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Role::Tax> inherits all attributes from L<Moose::Role> and implements
the following new ones.

=head2 C<tax_rule>

=head1 METHODS

L<Yetie::Domain::Role::Tax> inherits all methods from L<Moose::Role> and implements
the following new ones.

=head2 C<price_excl_tax>

    my $price_excl_tax = $product->price_excl_tax;

    my $price_excl_tax = $product->price_excl_tax( attr => 'shipping_fee' );

Arguments: C<attr> default 'price'

=head2 C<price_incl_tax>

    my $price_incl_tax = $product->price_incl_tax;

    my $price_incl_tax = $product->price_incl_tax( attr => 'shipping_fee' );

Arguments: C<attr> default 'price'

=head2 C<tax_amount>

    my $tax_amount = $product->tax_amount;

=head2 C<tax_rate>

    my $tax_amount = $product->tax_rate;

Return tax rate percentage.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Moose::Role>
