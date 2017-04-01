package Markets::Domain::Factory::Entity::Cart;
use Mojo::Base 'Markets::Domain::Factory';
use Markets::Domain::Collection qw/c/;

sub construct {
    my $self = shift;

    my $params = $self->params;
    my $cart_data = delete $params->{cart_data} || {};

    my %entities = ( items => 'entity-item', shipments => 'entity-shipment' );
    foreach my $attr ( keys %entities ) {
        my $data = $cart_data->{$attr} || [];
        my @array;
        push @array, $self->app->factory( $entities{$attr}, $_ ) for @{$data};
        $params->{$attr} = c(@array);
    }

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
