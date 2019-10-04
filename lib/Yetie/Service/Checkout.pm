package Yetie::Service::Checkout;
use Mojo::Base 'Yetie::Service';

sub create {
    my $self = shift;

    $self->server_session->data( checkout => {} );
    my $checkout = $self->factory('entity-checkout')->construct();
    return $checkout;
}

sub delete {
    my $self = shift;

    $self->server_session->clear('checkout');
    return;
}

sub load {
    my $self = shift;

    my $data = $self->server_session->data('checkout');
    return $self->create if !$data;

    my $checkout = $self->factory('entity-checkout')->construct($data);
    return $checkout;
}

sub update {
    my ( $self, $entity ) = @_;

    $self->server_session->data( checkout => $entity->to_data );
    return;
}

1;
__END__

=head1 NAME

Yetie::Service::Checkout

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Service::Checkout> inherits all attributes from L<Yetie::Service> and implements
the following new ones.

=head1 METHODS

L<Yetie::Service::Checkout> inherits all methods from L<Yetie::Service> and implements
the following new ones.

=head2 C<create>

    my $checkout = $service->create;

Return L<Yetie::Domain::Entity::Checkout> object.

=head2 C<delete>

    $service->delete;

=head2 C<load>

    my $checkout = $service->load;

Return L<Yetie::Domain::Entity::Checkout> object.

=head2 C<update>

    $service->update($checkout_obj);

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
