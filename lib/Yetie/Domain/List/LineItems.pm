package Yetie::Domain::List::LineItems;
use Yetie::Domain::Base 'Yetie::Domain::List';

sub total_amount {
    my $self = shift;

    my $total_amount = 0;
    $self->each( sub { $total_amount += $_->subtotal } );
    return $total_amount;
}

1;
__END__

=head1 NAME

Yetie::Domain::List::LineItems

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::List::LineItems> inherits all attributes from L<Yetie::Domain::List> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::List::LineItems> inherits all methods from L<Yetie::Domain::List> and implements
the following new ones.

=head2 C<total_amount>

    my $total_amount = $items->total_amount;

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::List>
