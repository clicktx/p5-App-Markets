package Yetie::Factory::Entity::Checkout;
use Mojo::Base 'Yetie::Factory';

sub cook {
    my $self = shift;

    $self->aggregate( transaction => 'entity-transaction', $self->{transaction} );
}

1;
__END__

=head1 NAME

Yetie::Factory::Entity::Checkout

=head1 SYNOPSIS

    my $entity = Yetie::Factory::Entity::Checkout->new( %args )->construct();

    # In controller
    my $entity = $c->factory('entity-checkout')->construct(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Factory::Entity::Checkout> inherits all attributes from L<Yetie::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Factory::Entity::Checkout> inherits all methods from L<Yetie::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Factory>
