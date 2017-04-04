package Markets::Domain::Factory::Entity::Cart;
use Mojo::Base 'Markets::Domain::Factory';
use Markets::Domain::Collection qw/c/;

sub cook {
    my $self = shift;

    my $cart_data = delete $self->{cart_data} || {};
    my %entities = ( items => 'entity-item', shipments => 'entity-shipment' );
    foreach my $key ( keys %entities ) {
        my $data = $cart_data->{$key} || [];
        my @array;
        push @array, $self->factory( $entities{$key}, $_ )->create for @{$data};
        $self->params( $key => c(@array) );
    }
}

1;
__END__

=head1 NAME

Markets::Domain::Factory::Entity::Cart

=head1 SYNOPSIS

    my $entity = Markets::Domain::Factory::Entity::Cart->new( %args )->create;

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Domain::Factory::Entity::Cart> inherits all attributes from L<Markets::Domain::Factory> and implements
the following new ones.

=head1 METHODS

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

 L<Markets::Domain::Factory>
