package Markets::Domain::Factory::Entity::SalesOrder;
use Mojo::Base 'Markets::Domain::Factory';

# code from Factory::Entity::Cart
# sub cook {
#     my $self = shift;
# 
#     # billing_address
#     my $billing_address = $self->factory('entity-address')->create( $self->{billing_address} || {} );
#     $self->param( billing_address => $billing_address );
# 
#     # Aggregate items
#     $self->aggregate( 'items', 'entity-selling_item', $self->param('items') || [] );
# 
#     # Aggregate shipments
#     my $param = $self->param('shipments') || [ {} ];
#     push @{$param}, {} unless @{$param};    # NOTE: At the time of "$param eq []"
#     $self->aggregate( 'shipments', 'entity-shipment', $param );
# }

1;
__END__

=head1 NAME

Markets::Domain::Factory::Entity::SalesOrder

=head1 SYNOPSIS

    my $entity = Markets::Domain::Factory::Entity::SalesOrder->new( %args )->create;

    # In controller
    my $entity = $c->factory('entity-sales_order')->create(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Domain::Factory::Entity::SalesOrder> inherits all attributes from L<Markets::Domain::Factory> and implements
the following new ones.

=head1 METHODS

L<Markets::Domain::Factory::Entity::SalesOrder> inherits all methods from L<Markets::Domain::Factory> and implements
the following new ones.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

 L<Markets::Domain::Factory>
