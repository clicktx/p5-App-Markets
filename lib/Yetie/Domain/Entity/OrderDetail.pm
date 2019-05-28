package Yetie::Domain::Entity::OrderDetail;
use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::Entity';

has page_title => ( is => 'ro', default => 'Order Details' );
has created_at => ( is => 'ro' );
has updated_at => ( is => 'ro' );
has customer         => ( is => 'ro', default => sub { __PACKAGE__->factory('entity-customer')->construct() } );
has billing_address  => ( is => 'ro', default => sub { __PACKAGE__->factory('entity-address')->construct() } );
has shipping_address => ( is => 'ro', default => sub { __PACKAGE__->factory('entity-address')->construct() } );
has items            => ( is => 'ro', default => sub { __PACKAGE__->factory('list-line_items')->construct() } );
has purchased_on     => ( is => 'ro', default => q{} );
has order_status     => ( is => 'ro', default => q{} );

sub bill_to_name { return shift->billing_address->line1 }

sub ship_to_name { return shift->shipping_address->line1 }

sub total_amount { return shift->items->total_amount }

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::Entity::OrderDetail

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::OrderDetail> inherits all attributes from L<Yetie::Domain::Entity> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Entity::OrderDetail> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<bill_to_name>

=head2 C<ship_to_name>

=head2 C<total_amount>

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>
