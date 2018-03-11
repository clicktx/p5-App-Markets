package Yetie::Domain::Entity::Category;
use Yetie::Domain::Base 'Yetie::Domain::Entity::Page';

has title     => '';
has parent_id => undef;
has products  => sub { __PACKAGE__->collection };

1;
__END__

=head1 NAME

Yetie::Domain::Entity::Category

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::Category> inherits all attributes from L<Yetie::Domain::Entity::Page> and implements
the following new ones.

=head2 C<title>

=head2 C<parent_id>

Return parent category ID.
If the root category, return C<undefined>.

=head2 C<products>

Return L<Yetie::Schema::ResultSet::Product> object or C<undefined>.

=head1 METHODS

L<Yetie::Domain::Entity::Category> inherits all methods from L<Yetie::Domain::Entity::Page> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity::Page>, L<Yetie::Domain::Entity>
