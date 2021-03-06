package Yetie::Domain::Entity::Customer;
use Crypt::ScryptKDF qw(scrypt_hash_verify);

use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::Entity';

has created_at => ( is => 'ro' );
has updated_at => ( is => 'ro' );
has password   => ( is => 'ro', default => sub { __PACKAGE__->factory('value-password')->construct() } );
has emails     => ( is => 'ro', default => sub { __PACKAGE__->factory('list-emails')->construct() } );

sub has_password { return shift->password->value ? 1 : 0 }

sub is_member { return shift->id ? 1 : 0 }

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::Entity::Customer

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::Customer> inherits all attributes from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<emails>

    my $emails = $customer->emails;
    $emails->each( sub { ... } );

Return L<Yetie::Domain::Collection> object.
Elements are L<Yetie::Domain::Entity::Email> object.

=head2 C<password>

    my $password = $customer->password;

Return L<Yetie::Domain::Value::Password> object.

=head2 C<created_at>

=head2 C<updated_at>

=head1 METHODS

L<Yetie::Domain::Entity::Customer> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<has_password>

    my $bool = $customer->has_password;

Returns true if a password has been set.

=head2 C<is_member>

    my $bool = $customer->is_member;

Returns true if registered.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Value::Password>, L<Yetie::Domain::Entity::Email>, L<Yetie::Domain::Entity>
