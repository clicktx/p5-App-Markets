package Yetie::Factory::Entity::OrderLineItem;
use Mojo::Base 'Yetie::Factory::Entity::LineItem';

1;
__END__

=head1 NAME

Yetie::Factory::Entity::OrderLineItem

=head1 SYNOPSIS

    my $entity = Yetie::Factory::Entity::OrderLineItem->new( %args )->construct();

    # In controller
    my $entity = $c->factory('entity-order_line_item')->construct(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Factory::Entity::OrderLineItem> inherits all attributes from L<Yetie::Factory::Entity::LineItem> and implements
the following new ones.

=head1 METHODS

L<Yetie::Factory::Entity::OrderLineItem> inherits all methods from L<Yetie::Factory::Entity::LineItem> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Factory::Entity::LineItem>
