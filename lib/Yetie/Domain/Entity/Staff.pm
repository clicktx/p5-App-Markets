package Yetie::Domain::Entity::Staff;
use Yetie::Domain::Entity;
use Crypt::ScryptKDF qw(scrypt_hash_verify);

has login_id   => undef;
has created_at => undef;
has updated_at => undef;
has password   => sub { __PACKAGE__->factory('value-password') };

sub is_staff { shift->id ? 1 : 0 }

1;
__END__

=head1 NAME

Yetie::Domain::Entity::Staff

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::Staff> inherits all attributes from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<id>

    my $id = $staff->id;

=head2 C<login_id>

    my $login_id = $staff->login_id;

Return LoginID.

=head2 C<password>

    my $password = $customer->password;

Return L<Yetie::Domain::Value::Password> object.

=head2 C<created_at>

=head2 C<updated_at>

=head1 METHODS

L<Yetie::Domain::Entity::Staff> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<is_staff>

    my $bool = $staff->is_staff;

Return boolean value.

=head2 C<verify_password>

    my $bool = $staff->verify_password($password);

Returns true if authenticated.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Value::Password>, L<Yetie::Domain::Entity>
