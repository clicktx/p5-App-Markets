package Yetie::Domain::Entity::ProductCategory;
use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::Entity';

has id => (
    is       => 'ro',
    init_arg => 'category_id',
);
has ancestors => (
    is      => 'ro',
    isa     => 'Yetie::Domain::List::CategoryAncestors',
    default => sub { shift->factory('list-category_ancestors')->construct() }
);
has category_id => ( is => 'ro', default => 0 );
has is_primary  => ( is => 'ro', default => 0 );
has title       => ( is => 'ro', default => q{} );

override to_hash => sub {
    my $hash = super();
    for (qw(id title ancestors)) { delete $hash->{$_} }
    return $hash;
};

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::Entity::ProductCategory

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::ProductCategory> inherits all attributes from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<id>

=head2 C<ancestors>

L<Yetie::Domain::List::CategoryAncestors>

=head2 C<category_id>

=head2 C<is_primary>

=head2 C<title>

=head1 METHODS

L<Yetie::Domain::Entity::ProductCategory> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>
