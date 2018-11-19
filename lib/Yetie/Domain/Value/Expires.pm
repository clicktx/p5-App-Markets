package Yetie::Domain::Value::Expires;
use Yetie::Domain::Base 'Yetie::Domain::Value';

our $default_expires_delta = 600;

sub is_expired {
    my $self = shift;

    my $expires = $self->value;
    my $now     = time;
    return $expires - $now < 0 ? 1 : 0;
}

sub new {
    my $class = shift;
    my $arg = shift // '';

    # +expires_delta
    $arg =~ /(\A\+)(\d+)/;
    $arg = time + $2 if $1;

    my $expires = $arg ? $arg : time + $default_expires_delta;
    return $class->SUPER::new( value => $expires );
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
    my $expires = Yetie::Domain::Value::Expires->new('+3600');

    # Set $utc
    my $expires = Yetie::Domain::Value::Expires->new($utc);

=head1 ATTRIBUTES

L<Yetie::Domain::Value::Expires> inherits all attributes from L<Yetie::Domain::Value> and implements
the following new ones.

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

L<Yetie::Domain::Value>
