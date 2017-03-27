package Markets::Domain::Factory::Entity::Cart;
use Mojo::Base 'Markets::Domain::Factory';
use Mojo::Collection qw/c/;

sub construct {
    my $self = shift;

    my $params = $self->params;
    my $cart_data = delete $params->{cart_data} || {};
    my $data;

    my @items;
    $data = $cart_data->{items} || [];
    foreach my $item ( @{$data} ) {
        push @items, $self->app->factory( 'entity-item', $item );
    }
    $params->{items} = c(@items);

    my @shipments;
    $data = $cart_data->{shipments} || [];
    foreach my $shipment ( @{$data} ) {
        push @shipments, $self->app->factory( 'entity-shipment', $shipment );
    }
    $params->{shipments} = c(@shipments);

    return $self->construct_class->new($params);
}

1;
__END__

=head1 NAME

Markets::Domain::Factory::Entity::Cart

=head1 SYNOPSIS

    # In controller
    my $obj = $c->factory( 'entity-cart', %args );

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Domain::Factory::Entity::Cart> inherits all attributes from L<Markets::Domain::Factory> and implements
the following new ones.

=head1 METHODS

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

 L<Markets::Domain::Factory>
