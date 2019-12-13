package Yetie::Domain::Entity::CartItem;
use Moose;
use namespace::autoclean;

use MooseX::Types::Common::Numeric qw(PositiveInt);

extends 'Yetie::Domain::Entity::LineItem';

has product_id => (
    is     => 'ro',
    isa    => PositiveInt,
    writer => 'set_product_id',
);
has product_title => (
    is     => 'ro',
    isa    => 'Str',
    writer => 'set_product_title',
);

override set_attributes => sub {
    my $self = shift;
    my $args = $self->args_to_hashref(@_);

    my $params    = delete $args->{price};
    my $new_price = $self->price->clone($params);
    $self->set_price($new_price);

    return super();
};

override _build__item_hash_sum => sub {
    my $self = shift;

    my $str;
    $str .= $self->product_id;

    # and more...

    return $self->SUPER::hash_code($str);
};

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::Entity::CartItem

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::CartItem> inherits all attributes from L<Yetie::Domain::Entity::LineItem> and implements
the following new ones.

=head2 C<product_id>

=head2 C<product_title>

=head1 METHODS

L<Yetie::Domain::Entity::CartItem> inherits all methods from L<Yetie::Domain::Entity::LineItem> and implements the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity::LineItem>, L<Yetie::Domain::Entity>
