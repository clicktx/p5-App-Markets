package Yetie::Factory::Entity::OrderDetail;
use Mojo::Base 'Yetie::Factory';

sub cook {
    my $self = shift;

    $self->aggregate( billing_address  => 'entity-address', $self->{billing_address}  || {} );
    $self->aggregate( shipping_address => 'entity-address', $self->{shipping_address} || {} );
    $self->aggregate( items => 'entity-order-items', { list => $self->param('items') || [] } );
}

1;
__END__

=head1 NAME

Yetie::Factory::Entity::OrderDetail

=head1 SYNOPSIS

    my $entity = Yetie::Factory::Entity::OrderDetail->new( %args )->construct();

    # In controller
    my $entity = $c->factory('entity-order_detail')->construct(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Factory::Entity::OrderDetail> inherits all attributes from L<Yetie::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Factory::Entity::OrderDetail> inherits all methods from L<Yetie::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Factory>
