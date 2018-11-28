package Yetie::Factory::Entity::Page::Orders;
use Mojo::Base 'Yetie::Factory';

sub cook {
    my $self = shift;

    # order_list
    $self->aggregate( order_list => 'list-order_details', $self->param('order_list') || [] );
}

1;
__END__

=head1 NAME

Yetie::Factory::Entity::Page::Orders

=head1 SYNOPSIS

    my $entity = Yetie::Factory::Entity::Page::Orders->new( %args )->construct();

    # In controller
    my $entity = $c->factory('entity-page-orders')->construct(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Factory::Entity::Page::Orders> inherits all attributes from L<Yetie::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Factory::Entity::Page::Orders> inherits all methods from L<Yetie::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Factory>
