package Yetie::Domain::Entity::TotalAmount;
use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::Entity';

has tax_rate => (
    is      => 'ro',
    default => 0,
);
has tax => (
    is  => 'ro',
    isa => 'Yetie::Domain::Value::Tax',
);
has total_excl_tax => (
    is  => 'ro',
    isa => 'Yetie::Domain::Value::Price',
);
has total_incl_tax => (
    is  => 'ro',
    isa => 'Yetie::Domain::Value::Price',
);

sub sum {
    my ( $self, $item ) = @_;
    return if $self->tax_rate != $item->tax_rate;

    return $self->new(
        tax_rate       => $self->tax_rate,
        tax            => $self->tax + $item->tax_amount,
        total_excl_tax => $self->total_excl_tax + $item->row_total_excl_tax,
        total_incl_tax => $self->total_incl_tax + $item->row_total_incl_tax,
    );
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
