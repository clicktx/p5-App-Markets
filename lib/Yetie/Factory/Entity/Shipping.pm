package Yetie::Factory::Entity::Shipping;
use Mojo::Base 'Yetie::Factory';

sub cook {
    my $self = shift;

    # Aggregate items
    $self->aggregate( fee => ( 'value-price', $self->param('fee') || {} ) );

    # tax rule
    $self->aggregate( tax_rule => 'entity-tax_rule', $self->param('tax_rule') || {} );
}

1;
__END__

=head1 NAME

Yetie::Factory::Entity::Shipping

=head1 SYNOPSIS

    my $entity = Yetie::Factory::Entity::Shipping->new( %args )->construct();

    # In controller
    my $entity = $c->factory('entity-shipping')->construct(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Factory::Entity::Shipping> inherits all attributes from L<Yetie::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Factory::Entity::Shipping> inherits all methods from L<Yetie::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Factory>
