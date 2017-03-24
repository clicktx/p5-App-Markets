package Markets::Domain::Entity::Cart;
use Mojo::Base 'Markets::Domain::Entity';

has [qw/ cart_id items shipments /];

has id => sub { $_[0]->hash_code( $_[0]->cart_id ) };

# has 'items';
# has item_count       => sub { shift->items->flatten->size };
# has original_total_price => 0;
# has total_price          => 0;
# has total_weight         => 0;

# cart.attributes
# cart.item_count
# cart.items
# cart.note
# cart.original_total_price
# cart.total_price
# cart.total_weight
use DDP;

sub add_item {
    my ( $self, $item ) = @_;

    my $items = $self->items;
    my $match;
    $items->each(
        sub {
            my ( $element, $i ) = @_;
            if ( $element->is_equal($item) ) {
                my $qty = $element->quantity + $item->quantity;
                $element->quantity($qty);
                $match = $i;
            }
        }
    );
    push @{$items}, $item if !$match;
    return $self;
}

sub to_hash {
    my $self = shift;
    my $hash = $self->SUPER::to_hash;

    # items
    my @items;
    $self->items->each( sub { push @items, $_->to_hash } );
    $hash->{items} = \@items;

    # shipments
    my @shipments;
    $self->shipments->each( sub { push @shipments, $_->to_hash } );
    $hash->{shipments} = \@shipments;

    delete $hash->{$_} for (qw/id cart_id/);
    return $hash;
}

sub total_item_count {
    my $self = shift;
    my $cnt  = 0;
    $self->items->each( sub     { $cnt += $_->quantity } );
    $self->shipments->each( sub { $cnt += $_->item_count } );
    return $cnt;
}

1;
__END__

=head1 NAME

Markets::Domain::Entity::Cart

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Domain::Entity::Cart> inherits all attributes from L<Markets::Domain::Entity> and implements
the following new ones.

=head1 METHODS

=head2 C<add_item>

    $cart->add_item( $item_entity_object );

Return Entity Cart Object.

=head2 C<to_hash>

    my $hash = $cart->to_hash;

Return Hash reference.

=head2 C<total_item_count>

    my $item_count = $cart->total_item_count;

Return all items quantity.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

 L<Markets::Domain::Entity>
