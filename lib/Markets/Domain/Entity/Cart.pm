package Markets::Domain::Entity::Cart;
use Mojo::Base 'Markets::Domain::Entity';

has [qw/ cart_id shipments /];

has entity_id => sub { shift->cart_id };

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

sub to_hash {
    my $self = shift;

    my @shipments;
    my @items;
    $self->shipments->each(
        sub {
            my ( $shipment, $i ) = @_;
            $i--;

            # Shipments
            my $data           = $shipment->to_hash;
            my $shipment_items = delete $data->{items};
            $shipments[$i] = $data;

            # Items
            $shipment_items->each( sub { push @{ $items[$i] }, shift->to_hash } );
        }
    );

    return { shipments => \@shipments, items => \@items, };
}

sub total_item_count {
    my $cnt = 0;
    shift->shipments->each( sub { $cnt += shift->item_count } );
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

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

 L<Markets::Domain::Entity>
