package Yetie::Factory::Entity::Page::Customers;
use Mojo::Base 'Yetie::Factory';

sub cook {
    my $self = shift;

    $self->aggregate_collection( customer_list => 'entity-customer', $self->param('customer_list') || [] );
}

1;
__END__

=head1 NAME

Yetie::Factory::Entity::Page::Customers

=head1 SYNOPSIS

    my $entity = Yetie::Factory::Entity::Page::Customers->new( %args )->construct();

    # In controller
    my $entity = $c->factory('entity-page-customers')->construct(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Factory::Entity::Page::Customers> inherits all attributes from L<Yetie::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Factory::Entity::Page::Customers> inherits all methods from L<Yetie::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Factory>
