package Yetie::Factory::List::OrderItems;
use Mojo::Base 'Yetie::Factory';

sub cook {
    my $self = shift;

    $self->aggregate_collection( list => 'entity-order_item', $self->param('list') || [] );
}

1;
__END__

=head1 NAME

Yetie::Factory::List::OrderItems

=head1 SYNOPSIS

    my $entity = Yetie::Factory::List::OrderItems->new( %args )->construct();

    # In controller
    my $entity = $c->factory('list-order_items')->construct(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Factory::List::OrderItems> inherits all attributes from L<Yetie::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Factory::List::OrderItems> inherits all methods from L<Yetie::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Factory>
