package Yetie::Domain::Factory::Page::Orders;
use Mojo::Base 'Yetie::Domain::Factory';

sub cook {
    my $self = shift;

    $self->aggregate( order_list => 'entity-order', $self->param('order_list') || [] );
}

1;
__END__

=head1 NAME

Yetie::Domain::Factory::Page::Orders

=head1 SYNOPSIS

    my $entity = Yetie::Domain::Factory::Page::Orders->new( %args )->create;

    # In controller
    my $entity = $c->factory('entity-page-orders')->create(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Factory::Page::Orders> inherits all attributes from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Factory::Page::Orders> inherits all methods from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Domain::Factory>
