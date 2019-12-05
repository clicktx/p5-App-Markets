package Yetie::Domain::Entity::OrderLineItem;
use Moose;
use namespace::autoclean;

extends 'Yetie::Domain::Entity::LineItem';

sub to_data {
    my $self = shift;

    return {
        id         => $self->id,
        product_id => $self->product_id,
        quantity   => $self->quantity,
        price      => {
            %{ $self->price->to_data },
            is_tax_included => $self->price->is_tax_included,
            tax_rule_id     => $self->tax_rule->id,
        },
    };
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::Entity::OrderLineItem

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::OrderLineItem> inherits all attributes from L<Yetie::Domain::Entity::LineItem> and L<Yetie::Domain::Role::Tax>.

Implements the following new ones.

=head1 METHODS

L<Yetie::Domain::Entity::OrderLineItem> inherits all methods from L<Yetie::Domain::Entity::LineItem> and L<Yetie::Domain::Role::Tax>.

Implements the following new ones.

=head2 C<to_data>

Override method.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity::LineItem>, L<Yetie::Domain::Role::Tax>, L<Yetie::Domain::Entity>
