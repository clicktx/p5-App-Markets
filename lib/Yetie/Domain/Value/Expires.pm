package Yetie::Domain::Value::Expires;
use Moo;
extends 'Yetie::Domain::Value';

our $default_expires_delta = 600;

has expires_delta => ( is => 'ro', default => 600 );

has '+value' => (
    default => sub { time + shift->expires_delta },
);

sub is_expired {
    my $self = shift;

    my $expires = $self->value // 0;
    my $now = time;
    return $expires - $now < 0 ? 1 : 0;
}

1;
__END__

=head1 NAME

Yetie::Domain::Value::Expires

=head1 SYNOPSIS

=head1 DESCRIPTION

    # UTC +600 second
    my $expires = Yetie::Domain::Value::Expires->new;

    # Expires delta
    my $expires = Yetie::Domain::Value::Expires->new( expires_delta => 3600 );

    # Set $utc
    my $expires = Yetie::Domain::Value::Expires->new( value => $utc );

=head1 ATTRIBUTES

L<Yetie::Domain::Value::Expires> inherits all attributes from L<Yetie::Domain::Value> and implements
the following new ones.

=head2 C<expires_delta>

    my $delta = $expires->expires_delta;

=head1 METHODS

L<Yetie::Domain::Value::Expires> inherits all methods from L<Yetie::Domain::Value> and implements
the following new ones.

=head2 C<is_expired>

    my $bool = $expires->is_expired;

Check it is expired.
Returns true if expired.

Return boolean value.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Value>, L<Moo>
