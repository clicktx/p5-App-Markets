package Markets::Domain::Entity::Category;
use Markets::Domain::Entity;

has breadcrumb => sub { [] };
has 'products';
has title   => '';

1;
__END__

=head1 NAME

Markets::Domain::Entity::Category

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Domain::Entity::Category> inherits all attributes from L<Markets::Domain::Entity> and implements
the following new ones.

=head2 C<breadcrumb>

Return Array reference.

=head2 C<products>

Return L<Markets::Schema::ResultSet::Product> object or C<undefined>.

=head2 C<title>

=head1 METHODS

L<Markets::Domain::Entity::Category> inherits all methods from L<Markets::Domain::Entity> and implements
the following new ones.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Domain::Entity>
