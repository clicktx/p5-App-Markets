package Markets::Domain::Entity::Product;
use Markets::Domain::Entity;
use Carp qw/croak/;

has [qw(title description price)];

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

=head1 METHODS

L<Markets::Domain::Entity::Product> inherits all methods from L<Markets::Domain::Entity> and implements
the following new ones.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

 L<Markets::Domain::Entity>