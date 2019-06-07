package Yetie::Domain::Value::Price;
use Moose;
extends 'Yetie::Domain::Value';

use Carp qw(croak);

has tax_rate => ( is => 'ro' );
has tax      => ( is => 'ro' );

sub add_price {
    my ( $self, $value ) = @_;
    return $self->value + $value;
}

# without_tax
# tax_included
# displayPriceIncludingTax
# excluding
sub exclude_tax {
    my $self = shift;
    return $self->value;
}

# $price->including_tax;
sub include_tax {
    my $self = shift;

    # return $self->value + $self->tax;
    $self->add_price( $self->tax );
}

# sub new {
#     my $class = shift;
#     my $self  = $class->SUPER::new(@_);

#     croak 'Argument cannot be less than zero' if $self->value < 0;

#     return $self;
# }
sub validate {
    my $self = shift;
    croak 'Argument cannot be less than zero' if $self->value < 0;
    return;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::Value::Price

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Value::Price> inherits all attributes from L<Yetie::Domain::Value> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Value::Price> inherits all methods from L<Yetie::Domain::Value> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Value>
