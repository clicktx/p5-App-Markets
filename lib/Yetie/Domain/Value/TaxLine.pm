package Yetie::Domain::Value::TaxLine;
use Moose;
extends 'Yetie::Domain::Value';

has rate  => ( is => 'ro' );
has title => ( is => 'ro' );

sub price { return shift->value }

sub rate_percentage { return shift->rate * 100 }

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::Value::TaxLine

=head1 SYNOPSIS

=head1 DESCRIPTION

    Yetie::Domain::Value::TaxLine->new(
        rate    => 0.1,
        title   => 'GST',
        value   => 80,
    );

=head1 ATTRIBUTES

L<Yetie::Domain::Value::TaxLine> inherits all attributes from L<Yetie::Domain::Value> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Value::TaxLine> inherits all methods from L<Yetie::Domain::Value> and implements
the following new ones.

=head2 C<price>

    # $80
    say '$' . $tax->price;

=head2 C<rate_percenteage>

    # 10%
    say $tax->rate_percentage . '%';

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Value>
