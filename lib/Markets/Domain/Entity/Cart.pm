package Markets::Domain::Entity::Cart;
use Mojo::Base 'Markets::Domain::Entity';
use Mojo::Collection qw/c/;

has [qw/ items shipments /];

has id => sub { $_[0]->hash_code( $_[0]->cart_id ) };
has cart_id => '';

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

    $self->is_modified(1);
    return $self;
}

sub clear {
    my $self = shift;

    # Remove all data
    $self->$_( c() ) for (qw/items shipments/);

    $self->is_modified(1);
    return $self;
}

sub clone {
    my $self  = shift;
    my $clone = $self->SUPER::clone;
    $clone->items( $self->items->map( sub         { $_->clone } ) ) if $self->items->can('map');
    $clone->shipments( $self->shipments->map( sub { $_->clone } ) ) if $self->shipments->can('map');
    return $clone;
}

# NOTE: アクセス毎に呼ばれる。Controller::Catalog::finalize
#       items,shipments,shipments->itemsの全てを検査する必要があるか？
#       速度に問題はないか？
sub is_modified {

    # @_ > 1 ? $_[0]->_is_modified( $_[1] ) : $_[0]->_is_modified
    my $self = shift;

    # Setter
    return $self->_is_modified(1) if @_;

    # Getter
    return 1 if $self->_is_modified;

    my $is_modified = 0;
    $self->$_->each( sub { $is_modified = 1 if $_->is_modified } ) for (qw/items shipments/);
    return $is_modified;
}

sub merge {
    my ( $self, $stored ) = ( shift->clone, shift->clone );

    # items
    foreach my $item ( @{ $stored->items } ) {
        $self->items->each(
            sub {
                my ( $e, $i ) = @_;
                if ( $e->is_equal($item) ) {
                    $item->quantity( $e->quantity + $item->quantity );
                    splice @{ $self->items }, $i - 1, 1;
                }
            }
        );
    }
    push @{ $stored->items }, @{ $self->items };

    # shipments
    # TODO: [WIP]

    $stored->is_modified(1);
    return $stored;
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

    # Remove no need data
    delete $hash->{$_} for (qw/id cart_id _is_modified/);
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

=head2 C<cart_id>

=head2 C<id>

=head2 C<items>

    my $items = $cart->items;
    $items->each( sub { ... } );

Return L<Mojo::Collection> object.
Elements is L<Markets::Domain::Entity::Item> object.

=head2 C<shipments>

    my $shipments = $cart->shipments;
    $shipments->each( sub { ... } );

Return L<Mojo::Collection> object.
Elements is L<Markets::Domain::Entity::Shipment> object.

=head1 METHODS

=head2 C<add_item>

    $cart->add_item( $item_entity_object );

Return Entity Cart Object.

=head2 C<is_modified>

    my $bool = $cart->is_modified;

Return boolean value.

=head2 C<merge>

    my $merged = $cart->merge($stored_cart);

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
