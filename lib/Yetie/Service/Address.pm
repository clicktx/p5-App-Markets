package Yetie::Service::Address;
use Mojo::Base 'Yetie::Service';

sub get_address_types {
    my $self = shift;

    return $self->cache('address_types') if $self->cache('address_types');

    my $rs = $self->resultset('Address::Type')->search();
    my $address_types = $self->factory('list-address_types')->construct( list => $rs->to_data );
    $self->cache( address_types => $address_types );
    return $address_types;
}

sub get_registered_id {
    my ( $self, $address ) = @_;

    my $registered = $self->resultset('Address')->search( { hash => $address->hash } )->first;
    return if !$registered or $registered->id == $address->id;

    return $registered->id;
}

sub update_address {
    my ( $self, $params ) = @_;

    my $address       = $self->factory('entity-address')->construct($params);
    my $registered_id = $self->get_registered_id($address);

    if ($registered_id) {

        # 登録済みの住所なのでchangeするか確認する
        say 'Registered address';
        die;
    }
    else {
        # Update address
        $self->resultset('Address')->search( { id => $address->id } )->update( $address->to_data );
    }
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

=head2 C<get_address_types>

    my $address_types = $servece->get_address_types;

Return L<Yetie::Domain::List::AddressTypes> object.

=head2 C<get_registered_id>

    my $address_entity = $c->factory('entity-address')->construct($form_params);
    my $address_id = $service->get_registered_id($address_entity);

Return address ID or C<undefined>.

=head2 C<update_address>

    $service->update_address(\%form_params);

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
