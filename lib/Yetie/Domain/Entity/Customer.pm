package Yetie::Domain::Entity::Customer;
use Yetie::Domain::Entity;
use Yetie::Domain::Entity::Password;
use Crypt::ScryptKDF qw(scrypt_hash_verify);

has logged_in  => 0;
has created_at => undef;
has updated_at => undef;
has password   => sub { __PACKAGE__->factory('entity-password') };
has emails     => sub { __PACKAGE__->collection };

sub is_registerd { shift->password->hash ? 1 : 0 }

sub verify_password {
    my ( $self, $password ) = @_;
    return 0 unless scrypt_hash_verify( $password, $self->password->hash );

    $self->logged_in(1);
    return 1;
}

1;
__END__

=head1 NAME

Yetie::Domain::Entity::Customer

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::Customer> inherits all attributes from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<logged_in>

    my $bool = $customer->logged_in;

Returns C<true> if the staff is logged in.

=head2 C<emails>

    my $emails = $customer->emails;
    $emails->each( sub { ... } );

Return L<Yetie::Domain::Collection> object.
Elements are L<Yetie::Domain::Entity::Email> object.

=head2 C<password>

    my $password = $customer->password;

Return L<Yetie::Domain::Entity::Password> object.

=head2 C<created_at>

=head2 C<updated_at>

=head1 METHODS

L<Yetie::Domain::Entity::Customer> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<is_registerd>

    my $bool = $customer->is_registerd;

Returns true if registered.

=head2 C<verify_password>

    my $bool = $customer->verify_password($password);

Once the password is authenticated, L</logged_in> attribute is set to true.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity::Password>, L<Yetie::Domain::Entity::Email>, L<Yetie::Domain::Entity>
