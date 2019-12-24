package Yetie::Domain::Entity::LineItem;
use Moose;
use namespace::autoclean;

extends 'Yetie::Domain::Entity';

with 'Yetie::Domain::Role::Tax';

has _item_hash_sum => (
    is       => 'ro',
    lazy     => 1,
    builder  => '_build__item_hash_sum',
    reader   => 'item_hash_sum',
    init_arg => undef,
);
has _row_total_excl_tax => (
    is       => 'ro',
    isa      => 'Yetie::Domain::Value::Price',
    lazy     => 1,
    builder  => '_build__row_total_excl_tax',
    reader   => 'row_total_excl_tax',
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
    is      => 'ro',
    isa     => 'Yetie::Domain::Value::Price',
    default => sub { __PACKAGE__->factory('value-price')->construct() },
    writer  => 'set_price',
);
has quantity => (
    is     => 'ro',
    isa    => 'Int',
    writer => 'set_quantity',
);

# XXX: _target_attributes (_hashing_keys) を作ってarray_refを設定？
# for my $attr(@$attrs){ $str .= "$attr:" . $self->$attr . ";" }
sub _build__item_hash_sum {
    my $self = shift;

    my $str;
    $str .= $self->id;

    # and more...

    return $self->SUPER::hash_code($str);
}

sub _build__row_total_excl_tax {
    my $self = shift;
    return $self->price_excl_tax * $self->quantity;
}

sub _build__row_total_incl_tax {
    my $self = shift;
    return $self->price_incl_tax * $self->quantity;
}

sub equals { return $_[0]->item_hash_sum eq $_[1]->item_hash_sum ? 1 : 0 }

sub row_tax_amount {
    my $self = shift;

    my $tax = $self->factory('value-tax')->construct();
    $tax += $self->row_total_incl_tax->clone( is_tax_included => 0 ) - $self->row_total_excl_tax;
    return $tax;
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

=head2 C<item_hash_sum>

    my $item_hash_sum = $item->item_hash_sum;

Return SHA1 string.
This method gets a string identifying product item.

=head2 C<quantity>

=head2 C<price>

Return L<Yetie::Domain::Value::Price> object.

=head2 C<row_total_incl_tax>

Return L<Yetie::Domain::Value::Price> object.

=head2 C<row_total_incl_tax>

Return L<Yetie::Domain::Value::Price> object.

=head1 METHODS

L<Yetie::Domain::Entity::LineItem> inherits all methods from L<Yetie::Domain::Entity> and L<Yetie::Domain::Role::Tax>.

Implements the following new ones.

=head2 C<equals>

    my $bool = $item->equals($other_item);

=head2 C<row_tax_amount>

    my $tax = $item->row_tax_amount;

Return L<Yetie::Domain::Value::Tax> object.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Role::Tax>, L<Yetie::Domain::Entity>
