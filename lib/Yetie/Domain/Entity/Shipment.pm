package Yetie::Domain::Entity::Shipment;
use Moose;
use namespace::autoclean;

extends 'Yetie::Domain::Entity::LineItem';

override 'to_order_data' => sub {
    my $self = shift;

    my $data = super();
    delete $data->{$_} for qw(quantity);
    $data->{shipment_price} = { price => delete $data->{price} };

    return $data;
};

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::Entity::Shipment

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::Shipment> inherits all attributes from L<Yetie::Domain::Entity::LineItem>
and Implements the following new ones.

=head1 METHODS

L<Yetie::Domain::Entity::Shipment> inherits all methods from L<Yetie::Domain::Entity::LineItem>
and Implements the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity::LineItem>, L<Yetie::Domain::Entity>
