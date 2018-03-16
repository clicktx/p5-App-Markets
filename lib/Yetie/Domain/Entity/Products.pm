package Yetie::Domain::Entity::Products;
use Yetie::Domain::Base 'Yetie::Domain::Entity::Page';

has product_list => sub { Yetie::Domain::Collection->new };

sub each { shift->product_list->each(@_) }

1;
__END__

=head1 NAME

Yetie::Domain::Entity::Products

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::Products> inherits all attributes from L<Yetie::Domain::Entity::Page> and implements
the following new ones.

=head2 C<product_list>

    my $collection = $products->product_list;

Return L<Yetie::Domain::Collection> object.

=head1 METHODS

L<Yetie::Domain::Entity::Products> inherits all methods from L<Yetie::Domain::Entity::Page> and implements
the following new ones.

=head2 C<each>

    $products->each(...);

    # Longer version
    $products->product_list->each(...);

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity::Page>, L<Yetie::Domain::Entity>
