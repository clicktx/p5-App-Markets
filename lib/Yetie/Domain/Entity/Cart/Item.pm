package Yetie::Domain::Entity::Cart::Item;
use Yetie::Domain::Base 'Yetie::Domain::Entity::SellingItem';

has hash => sub { shift->hash_code };

sub equal { shift->hash eq shift->hash ? 1 : 0 }

sub hash_code {
    my $self = shift;

    my $str = '';
    $str .= $self->product_id;

    return $self->SUPER::hash_code($str);
}

sub to_data {
    my $self = shift;

    my $data = $self->SUPER::to_data;
    delete $data->{hash};
    return $data;
}

1;
__END__

=head1 NAME

Yetie::Domain::Entity::Cart::Item

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::Cart::Item> inherits all attributes from L<Yetie::Domain::Entity::SellingItem> and implements
the following new ones.

=head2 C<hash>

See L</hash_code>

=head2 C<id>

=head2 C<product_id>

=head2 C<product_title>

=head2 C<quantity>

=head2 C<price>

=head1 METHODS

L<Yetie::Domain::Entity::Cart::Item> inherits all methods from L<Yetie::Domain::Entity::SellingItem> and implements
the following new ones.

=head2 C<hash_code>

    my $hash_code = $item->hash_code;

Return SHA1 string.
This method gets a string identifying items.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity::SellingItem>, L<Yetie::Domain::Entity>
