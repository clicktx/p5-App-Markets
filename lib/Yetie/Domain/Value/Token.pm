package Yetie::Domain::Value::Token;
use Yetie::Domain::Base 'Yetie::Domain::Value';
use Yetie::Util qw(uuid);

sub new {
    my $class = shift;
    my $args = @_ ? @_ > 1 ? {@_} : $_[0] : {};

    my $token = $args->{value} // uuid();
    return $class->SUPER::new( value => $token );
}

sub is_uuid {
    my $self = shift;
    my $r    = qr/[0-9A-F]/;
    return $self->value =~ qr/$r{8}\-$r{4}\-4$r{3}\-[89AB]$r{3}\-$r{12}/ ? 1 : 0;
}

1;
__END__

=head1 NAME

Yetie::Domain::Value::Token

=head1 SYNOPSIS

=head1 DESCRIPTION

    # Create new token
    my $token = Yetie::Domain::Value::Token->new;

    # Set token
    my $token = Yetie::Domain::Value::Token->new( value => $token );

=head1 ATTRIBUTES

L<Yetie::Domain::Value::Token> inherits all attributes from L<Yetie::Domain::Value> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Value::Token> inherits all methods from L<Yetie::Domain::Value> and implements
the following new ones.

=head2 C<is_uuid>

    my $bool = $v->is_uuid;

Return boolean value.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Value>
