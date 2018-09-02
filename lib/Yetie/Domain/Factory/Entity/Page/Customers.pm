package Yetie::Domain::Factory::Entity::Page::Customers;
use Mojo::Base 'Yetie::Domain::Factory';

sub cook {
    my $self = shift;

    $self->aggregate_collection( customer_list => 'entity-customer', $self->param('customer_list') || [] );
}

1;
__END__

=head1 NAME

Yetie::Domain::Factory::Entity::Page::Customers

=head1 SYNOPSIS

    my $entity = Yetie::Domain::Factory::Entity::Page::Customers->new( %args )->create;

    # In controller
    my $entity = $c->factory('entity-page-customers')->create(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Factory::Entity::Page::Customers> inherits all attributes from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Factory::Entity::Page::Customers> inherits all methods from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Domain::Factory>
