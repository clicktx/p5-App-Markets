package Yetie::Factory::List::CartItems;
use Mojo::Base 'Yetie::Factory';

sub cook {
    my $self = shift;

    # Aggregate items
    $self->aggregate_collection( list => ( 'entity-cart-item', $self->param('list') ) );
}

1;
__END__

=head1 NAME

Yetie::Factory::List::CartItems

=head1 SYNOPSIS

    my $entity = Yetie::Factory::List::CartItems->new()->construct();

    # In controller
    my $entity = $c->factory('list-cart_items')->construct();

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Factory::List::CartItems> inherits all attributes from L<Yetie::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Factory::List::CartItems> inherits all methods from L<Yetie::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Factory>
