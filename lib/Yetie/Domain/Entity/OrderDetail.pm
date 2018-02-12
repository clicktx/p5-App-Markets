package Yetie::Domain::Entity::OrderDetail;
use Yetie::Domain::Entity;

has page_title => 'Order Details';
has created_at       => undef;
has updated_at       => undef;
has customer         => sub { __PACKAGE__->factory('entity-customer') };
has billing_address  => sub { __PACKAGE__->factory('entity-address') };
has shipping_address => sub { __PACKAGE__->factory('entity-address') };
has items            => sub { __PACKAGE__->factory('entity-order-items') };

has purchased_on => '';
has order_status => '';

sub bill_to_name { shift->billing_address->line1 }
sub ship_to_name { shift->shipping_address->line1 }
sub total_amount { shift->items->total_amount }

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

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>
