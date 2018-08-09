package Yetie::Service::Address;
use Mojo::Base 'Yetie::Service';

has resultset => sub { shift->schema->resultset('Address') };

sub get_registered_id {
    my ( $self, $address ) = @_;

    my $registered = $self->resultset->search( { hash => $address->hash } )->first;
    return if !$registered or $registered->id == $address->id;

    return $registered->id;
}

1;
__END__

=head1 NAME

Yetie::Service::Address

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Service::Address> inherits all attributes from L<Yetie::Service> and implements
the following new ones.

=head1 METHODS

L<Yetie::Service::Address> inherits all methods from L<Yetie::Service> and implements
the following new ones.

=head2 C<get_registered_id>

    my $address_entity = $c->factory('entity-address')->create($form_params);
    my $address_id = $service->get_registered_id($address_entity);

Return address ID or C<undefined>.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
