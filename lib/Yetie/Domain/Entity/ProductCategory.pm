package Yetie::Domain::Entity::ProductCategory;
use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::Entity';

with qw(Yetie::Domain::Role::CategoryAncestor);

has id => (
    is       => 'ro',
    init_arg => 'category_id',
);
has category_id => ( is => 'ro', default => 0 );
has is_primary  => ( is => 'ro', default => 0 );
has title       => ( is => 'ro', default => q{} );

override to_hash => sub {
    my $hash = super();
    for (qw(id title ancestors)) { delete $hash->{$_} }
    return $hash;
};

sub full_title {
    my ( $self, $options ) = ( shift, shift || {} );

    my $separator = $options->{separator} || '>';
    my $ancestors = $self->ancestors->list->reverse;
    my $title     = $self->title;
    $ancestors->each( sub { $title = $_->title . " $separator $title" } );
    return $title;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::Entity::ProductCategory

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::ProductCategory> inherits all attributes from L<Yetie::Domain::Entity>
and L<Yetie::Domain::Role::CategoryAncestor>,

and implements the following new ones.

=head2 C<id>

=head2 C<ancestors>

Inherits from L<Yetie::Domain::Role::CategoryAncestor>.

Return L<Yetie::Domain::List::CategoryTrees>

=head2 C<category_id>

=head2 C<is_primary>

=head2 C<title>

=head1 METHODS

L<Yetie::Domain::Entity::ProductCategory> inherits all methods from L<Yetie::Domain::Entity>
and L<Yetie::Domain::Role::CategoryAncestor>,

and implements the following new ones.

=head2 C<full_title>

    # foo > bar > baz
    my $full_title = $obj->full_title();

    # foo / bar / baz
    my %options = ( separetor => '/' );
    my $full_title = $obj->full_title( \%options );

=head4 OPTIONS

C<separator> default: ">"

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>
