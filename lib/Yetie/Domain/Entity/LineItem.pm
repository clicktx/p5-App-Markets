package Yetie::Domain::Entity::LineItem;
use Moose;
use namespace::autoclean;
use MooseX::Types::Common::Numeric qw(PositiveInt);
extends 'Yetie::Domain::Entity';

with 'Yetie::Domain::Role::Tax';

has _product_hash_code => (
    is       => 'ro',
    lazy     => 1,
    builder  => '_build__product_hash_code',
    reader   => 'product_hash_code',
    init_arg => undef,
);
has _row_total_incl_tax => (
    is       => 'ro',
    isa      => 'Yetie::Domain::Value::Price',
    lazy     => 1,
    builder  => '_build__row_total_incl_tax',
    reader   => 'row_total_incl_tax',
    init_arg => undef,
);
has price => (
    is      => 'rw',
    isa     => 'Yetie::Domain::Value::Price',
    default => sub { __PACKAGE__->factory('value-price')->construct() },
);
has product_id => (
    is  => 'rw',
    isa => PositiveInt,
);
has product_title => (
    is  => 'rw',
    isa => 'Str',
);
has quantity => (
    is  => 'rw',
    isa => 'Int',
);

override set_attributes => sub {
    my ( $self, $args ) = @_;

    my $price     = delete $args->{price};
    my $new_price = $self->price->set_value($price);
    $self->price($new_price);

    return super();
};

sub equals { return $_[0]->product_hash_code eq $_[1]->product_hash_code ? 1 : 0 }

sub _build__product_hash_code {
    my $self = shift;

    my $str;
    $str .= $self->product_id;

    # and more...

    return $self->SUPER::hash_code($str);
}

sub _build__row_total_incl_tax {
    my $self = shift;
    return $self->price_incl_tax * $self->quantity;
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

Return L<Yetie::Domain::Value::Price> object.

=head2 C<row_total_incl_tax>

Return L<Yetie::Domain::Value::Price> object.

=head1 METHODS

L<Yetie::Domain::Entity::LineItem> inherits all methods from L<Yetie::Domain::Entity> and L<Yetie::Domain::Role::Tax>.

Implements the following new ones.

=head2 C<equals>

    my $bool = $item->equals($other_item);

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Role::Tax>, L<Yetie::Domain::Entity>
