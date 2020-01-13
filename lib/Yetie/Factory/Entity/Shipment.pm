package Yetie::Factory::Entity::Shipment;
use Mojo::Base 'Yetie::Factory::Entity::LineItem';

1;
__END__

=head1 NAME

Yetie::Factory::Entity::Shipment

=head1 SYNOPSIS

    my $entity = Yetie::Factory::Entity::Shipment->new( %args )->construct();

    # In controller
    my $entity = $c->factory('entity-shipment')->construct(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Factory::Entity::Shipment> inherits all attributes from L<Yetie::Factory::Entity::LineItem> and implements
the following new ones.

=head1 METHODS

L<Yetie::Factory::Entity::Shipment> inherits all methods from L<Yetie::Factory::Entity::LineItem> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Factory::Entity::LineItem>, L<Yetie::Factory>
