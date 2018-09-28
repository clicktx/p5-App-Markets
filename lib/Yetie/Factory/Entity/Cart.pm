package Yetie::Factory::Entity::Cart;
use Mojo::Base 'Yetie::Factory';

sub cook {
    my $self = shift;

    # email
    $self->aggregate( email => ( 'value-email', $self->{email} || '' ) );

    # billing_address
    $self->aggregate( billing_address => ( 'entity-address', $self->{billing_address} || {} ) );

    # Aggregate items
    $self->aggregate( items => ( 'list-cart_items', $self->param('items') || [] ) );

    # Aggregate shipments
    $self->aggregate( shipments => ( 'list-shipments', $self->param('shipments') || [] ) );
}

1;
__END__

=head1 NAME

Yetie::Factory::Entity::Cart

=head1 SYNOPSIS

    my $entity = Yetie::Factory::Entity::Cart->new( %args )->construct();

    # In controller
    my $entity = $c->factory('entity-cart')->construct(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Factory::Entity::Cart> inherits all attributes from L<Yetie::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Factory::Entity::Cart> inherits all methods from L<Yetie::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Factory>
