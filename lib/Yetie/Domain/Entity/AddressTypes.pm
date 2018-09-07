package Yetie::Domain::Entity::AddressTypes;
use Yetie::Domain::Base 'Yetie::Domain::List';

sub get_id_by_name {
    my ( $self, $name ) = @_;
    my $address_type = $self->list->first( sub { $_->name eq $name } );
    $address_type ? $address_type->id : undef;
}

1;
__END__

=head1 NAME

Yetie::Domain::Entity::AddressTypes

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::AddressTypes> inherits all attributes from L<Yetie::Domain::List> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Entity::AddressTypes> inherits all methods from L<Yetie::Domain::List> and implements
the following new ones.

=head2 C<get_id_by_name>

    my $address_type_id = $entity->get_id_by_name('foo');

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::List>
