package Yetie::Domain::Entity::SalesItem;
use Moose;
use namespace::autoclean;

extends 'Yetie::Domain::Entity::CartItem';

sub to_order_data {
    my $self = shift;

    my $data = $self->to_data;

    delete $data->{tax_rule};
    $data->{price} = {
        %{ $self->price->to_data },
        is_tax_included => $self->price->is_tax_included,
        tax_rule_id     => $self->tax_rule->id,
    };
    return $data;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::Entity::SalesItem

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::SalesItem> inherits all attributes from L<Yetie::Domain::Entity::LineItem> and L<Yetie::Domain::Role::Tax>.

Implements the following new ones.

=head1 METHODS

L<Yetie::Domain::Entity::SalesItem> inherits all methods from L<Yetie::Domain::Entity::LineItem> and L<Yetie::Domain::Role::Tax>.

Implements the following new ones.

=head2 C<to_data>

Override method.

=head2 C<to_order_data>

    my $order_data = $item->to_order_data();

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity::LineItem>, L<Yetie::Domain::Role::Tax>, L<Yetie::Domain::Entity>
