package Yetie::Domain::Entity::Cart::Item;
use Yetie::Domain::Base 'Yetie::Domain::Entity::SellingItem';

has id => sub { shift->to_digest };

1;
__END__

=head1 NAME

Yetie::Domain::Entity::Cart::Item

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::Cart::Item> inherits all attributes from L<Yetie::Domain::Entity::SellingItem> and implements
the following new ones.

=head2 C<id>

=head2 C<product_id>

=head2 C<product_title>

=head2 C<quantity>

=head2 C<price>

=head1 METHODS

L<Yetie::Domain::Entity::Cart::Item> inherits all methods from L<Yetie::Domain::Entity::SellingItem> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity::SellingItem>, L<Yetie::Domain::Entity>
