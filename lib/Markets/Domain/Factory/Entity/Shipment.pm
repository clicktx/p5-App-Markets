package Markets::Domain::Factory::Entity::Shipment;
use Mojo::Base 'Markets::Domain::Factory';
use Mojo::Collection qw/c/;

sub construct {
    my $self = shift;

    my $params = $self->params;
    my $data = $params->{shipping_items} || [];

    my @shipping_items;
    foreach my $item ( @{$data} ) {
        push @shipping_items, $self->app->factory( 'entity-item', $item );
    }
    $params->{shipping_items} = c(@shipping_items);

    return $self->construct_class->new($params);
}

1;
__END__

=head1 NAME

Markets::Domain::Factory::Entity::Shipment

=head1 SYNOPSIS

    # In controller
    my $obj = $c->factory( 'entity-cart', %args );

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Domain::Factory::Entity::Shipment> inherits all attributes from L<Markets::Domain::Factory> and implements
the following new ones.

=head1 METHODS

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

 L<Markets::Domain::Factory>
