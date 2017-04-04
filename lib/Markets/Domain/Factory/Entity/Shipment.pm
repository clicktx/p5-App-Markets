package Markets::Domain::Factory::Entity::Shipment;
use Mojo::Base 'Markets::Domain::Factory';
use Markets::Domain::Collection qw/c/;

sub cook {
    my $self = shift;

    my $data = $self->{shipping_items} || [];
    my @shipping_items;
    foreach my $item ( @{$data} ) {
        push @shipping_items, $self->factory( 'entity-item', $item )->create;
    }

    $self->params( shipping_items => c(@shipping_items) );
}

1;
__END__

=head1 NAME

Markets::Domain::Factory::Entity::Shipment

=head1 SYNOPSIS

    # In controller
    my $entity = $c->factory( 'entity-cart', %args )->create;

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Domain::Factory::Entity::Shipment> inherits all attributes from L<Markets::Domain::Factory> and implements
the following new ones.

=head1 METHODS

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

 L<Markets::Domain::Factory>
