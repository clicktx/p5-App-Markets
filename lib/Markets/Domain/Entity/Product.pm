package Markets::Domain::Entity::Product;
use Markets::Domain::Entity;

has title              => '';
has description        => '';
has price              => 0;
has primary_category   => sub { Markets::Domain::Collection->new };
has product_categories => sub { Markets::Domain::Collection->new };

has created_at => undef;
has updated_at => undef;

1;
__END__

=head1 NAME

Markets::Domain::Entity::Product

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Domain::Entity::Product> inherits all attributes from L<Markets::Domain::Entity> and implements
the following new ones.

=head2 C<title>

=head2 C<description>

=head2 C<price>

=head2 C<primary_category>

Return L<Markets::Domain::Collection> object.

=head2 C<product_categories>

Return L<Markets::Domain::Collection> object.

=head2 C<created_at>

Return L<DateTime> object or C<undef>.

=head2 C<updated_at>

Return L<DateTime> object or C<undef>.

=head1 METHODS

L<Markets::Domain::Entity::Product> inherits all methods from L<Markets::Domain::Entity> and implements
the following new ones.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Domain::Entity>
