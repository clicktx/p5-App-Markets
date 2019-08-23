package Yetie::Domain::Entity::LineItem;
use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::Entity';

with 'Yetie::Domain::Role::Tax';

has _product_hash_code => (
    is       => 'ro',
    lazy     => 1,
    builder  => '_build__product_hash_code',
    reader   => 'product_hash_code',
    init_arg => undef,
);
has price => (
    is      => 'rw',
    isa     => 'Yetie::Domain::Value::Price',
    default => sub { __PACKAGE__->factory('value-price')->construct() },
);
has product_id    => ( is => 'rw' );
has product_title => ( is => 'rw' );
has quantity      => ( is => 'rw' );

override set_attributes => sub {
    my ( $self, $args ) = @_;

    my $price     = delete $args->{price};
    my $new_price = $self->price->set_value($price);
    $self->price($new_price);

    return super();
};

sub _build__product_hash_code {
    my $self = shift;

    my $str;
    $str .= $self->product_id;

    # and more...

    return $self->SUPER::hash_code($str);
}

sub equals { return $_[0]->product_hash_code eq $_[1]->product_hash_code ? 1 : 0 }

sub subtotal {
    my $self     = shift;
    my $subtotal = 0;

    $subtotal = $self->price * $self->quantity;
    return $subtotal;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::Entity::LineItem

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::LineItem> inherits all attributes from L<Yetie::Domain::Entity> and L<Yetie::Domain::Role::Tax>.

Implements the following new ones.

=head2 C<product_hash_code>

    my $product_hash_code = $item->product_hash_code;

Return SHA1 string.
This method gets a string identifying product item.

=head2 C<product_id>

=head2 C<product_title>

=head2 C<quantity>

=head2 C<price>

=head1 METHODS

L<Yetie::Domain::Entity::LineItem> inherits all methods from L<Yetie::Domain::Entity> and L<Yetie::Domain::Role::Tax>.

Implements the following new ones.

=head2 C<equals>

    my $bool = $item->equals($other_item);

=head2 C<subtotal>

    $item->subtotal

Returns the combined price of all the items in the row.
This is equal to C< $item-E<gt>price> times C<$item-E<gt>quantity>.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Role::Tax>, L<Yetie::Domain::Entity>
