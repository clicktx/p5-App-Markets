package Yetie::Domain::Factory::Entity::Page::Orders;
use Mojo::Base 'Yetie::Domain::Factory';

sub cook {
    my $self = shift;

    $self->aggregate_collection( order_list => 'entity-order_detail', $self->param('order_list') || [] );
}

1;
__END__

=head1 NAME

Yetie::Domain::Factory::Entity::Page::Orders

=head1 SYNOPSIS

    my $entity = Yetie::Domain::Factory::Entity::Page::Orders->new( %args )->construct();

    # In controller
    my $entity = $c->factory('entity-page-orders')->construct(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Factory::Entity::Page::Orders> inherits all attributes from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Factory::Entity::Page::Orders> inherits all methods from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Domain::Factory>
