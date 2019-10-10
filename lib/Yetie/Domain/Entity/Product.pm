package Yetie::Domain::Entity::Product;
use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::Entity';

with 'Yetie::Domain::Role::Tax';

has title       => ( is => 'rw', default => q{} );
has description => ( is => 'ro', default => q{} );

# FIXME: There are multiple prices!
has price => (
    is      => 'ro',
    isa     => 'Yetie::Domain::Value::Price',
    default => sub { __PACKAGE__->factory('value-price')->construct() },
);
has created_at => ( is => 'ro' );
has updated_at => ( is => 'ro' );
has product_categories => (
    is      => 'ro',
    lazy    => 1,
    default => sub { __PACKAGE__->factory('list-product_categories')->construct() }
);

# NOTE: admin/productでduplicateする時にDB保存しない場合は不要になる
override to_data => sub {
    my $self = shift;

    my $data = super();
    delete $data->{tax_rule};
    return $data;
};

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::Entity::Product

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::Product> inherits all attributes from L<Yetie::Domain::Entity> and L<Yetie::Domain::Role::Tax>.

Implements the following new ones.

=head2 C<title>

=head2 C<description>

=head2 C<price>

Return L<Yetie::Domain::Value::Price> object.

=head2 C<product_categories>

Return L<Yetie::Domain::List::ProductCategories> object.

=head2 C<created_at>

Return L<DateTime> object or C<undef>.

=head2 C<updated_at>

Return L<DateTime> object or C<undef>.

=head2 C<tax_rule>

Inherits from L<Yetie::Domain::Role::Tax>

=head1 METHODS

L<Yetie::Domain::Entity::Product> inherits all methods from L<Yetie::Domain::Entity> and L<Yetie::Domain::Role::Tax>.

Implements the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Role::Tax>, L<Yetie::Domain::Entity>, L<Yetie::Domain::Entity>
