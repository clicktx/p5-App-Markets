package Yetie::Domain::Value::Password;
use Moo;
use Crypt::ScryptKDF qw(scrypt_hash_verify);
extends 'Yetie::Domain::Value';

has created_at => ( is => 'ro' );

sub is_verify {
    my ( $self, $raw_password ) = @_;
    return scrypt_hash_verify( $raw_password, $self->value ) ? 1 : 0;
}

1;
__END__

=head1 NAME

Yetie::Domain::Value::Password

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Value::Password> inherits all attributes from L<Yetie::Domain::Value> and implements
the following new ones.

=head2 C<created_at>

=head1 METHODS

L<Yetie::Domain::Value::Password> inherits all methods from L<Yetie::Domain::Value> and implements
the following new ones.

=head2 C<is_verify>

    my $bool = $password->is_verify($raw_password);

Return boolean value.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Value>
