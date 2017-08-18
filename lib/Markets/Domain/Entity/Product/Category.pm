package Markets::Domain::Entity::Product::Category;
use Markets::Domain::Entity;
use Carp qw/croak/;

has id => sub { shift->category_id };
has product_id  => 0;
has category_id => 0;
has is_primary  => 0;
has detail      => sub { {} };
has title       => sub { shift->detail->{title} };

1;
__END__

=head1 NAME

Markets::Domain::Entity::Product::Category

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Domain::Entity::Product::Category> inherits all attributes from L<Markets::Domain::Entity> and implements
the following new ones.

=head2 C<id>

=head2 C<product_id>

=head2 C<category_id>

=head2 C<is_primary>

=head2 C<detail>

=head2 C<title>

=head1 METHODS

L<Markets::Domain::Entity::Product::Category> inherits all methods from L<Markets::Domain::Entity> and implements
the following new ones.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Domain::Entity>
