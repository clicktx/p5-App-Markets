package Yetie::Domain::List::TotalAmounts;
use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::List';

sub sum {
    my ( $self, $item ) = @_;

    my $first_row = $self->first( sub { $_->tax_rate == $item->tax_rate } );
    if ( !$first_row ) {
        $self->append(
            $self->factory('entity-total_amount')->construct(
                tax_rate       => $item->tax_rate,
                tax            => $item->tax_amount,
                total_excl_tax => $item->row_total_excl_tax,
                total_incl_tax => $item->row_total_incl_tax,
            )
        );
    }
    else {
        my $total = $first_row->sum($item);
        my $new_list = $self->list->grep( sub { $_->tax_rate != $total->tax_rate } );
        $self->list( $new_list->append($total) );
    }

    # Sort by tax_rate
    my $sorted = $self->list->sort( sub { $b->tax_rate <=> $a->tax_rate } );
    $self->list($sorted);
    return;
}

sub grand_total {
    my $self = shift;

    my $grand_total;
    $self->list->each( sub { $grand_total += $_->total_incl_tax } );
    return $grand_total || $self->factory('value-price')->construct;
}

sub has_many { return shift->list->size > 1 ? 1 : 0 }

sub taxes {
    my $self = shift;

    my $taxes;
    $self->list->each( sub { $taxes += $_->tax } );
    return $taxes || $self->factory('value-tax')->construct;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::List::TotalAmounts

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::List::TotalAmounts> inherits all attributes from L<Yetie::Domain::List> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::List::TotalAmounts> inherits all methods from L<Yetie::Domain::List> and implements
the following new ones.

=head2 C<sum>

Calculate total amount by tax bracket.

    $total_amounts->sum( $line_item );

=head2 C<grand_total>

    my $grand_total = $total_amounts->grand_total;

Return L<Yetie::Domain::Value::Price> object.

=head2 C<has_many>

    my $bool = $total_amounts->has_many;

=head2 C<taxes>

    my $taxes = $total_amounts->taxes;

Return L<Yetie::Domain::Value::Price> object.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::List>
