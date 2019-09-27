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

    $total->sum( $line_item );

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::List>
