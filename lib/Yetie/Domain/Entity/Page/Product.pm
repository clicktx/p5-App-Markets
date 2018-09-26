package Yetie::Domain::Entity::Page::Product;
use Yetie::Domain::Base 'Yetie::Domain::Entity::Page';

has title              => '';
has description        => '';
has price              => 0;
has created_at         => undef;
has updated_at         => undef;
has product_categories => sub { Yetie::Domain::Collection->new };

1;
__END__

=head1 NAME

Yetie::Domain::Entity::Page::Product

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::Page::Product> inherits all attributes from L<Yetie::Domain::Entity::Page> and implements
the following new ones.

=head2 C<title>

=head2 C<description>

=head2 C<price>

=head2 C<product_categories>

Return L<Yetie::Domain::Collection> object.

=head2 C<created_at>

Return L<DateTime> object or C<undef>.

=head2 C<updated_at>

Return L<DateTime> object or C<undef>.

=head1 METHODS

L<Yetie::Domain::Entity::Page::Product> inherits all methods from L<Yetie::Domain::Entity::Page> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity::Page>, L<Yetie::Domain::Entity>
