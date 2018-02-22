package Yetie::Domain::Entity::Account;
use Yetie::Domain::Entity;

has password => sub { __PACKAGE__->factory('entity-password') };
has created_at => undef;
has updated_at => undef;

1;
__END__

=head1 NAME

Yetie::Domain::Entity::Account

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::Account> inherits all attributes from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<id>

    my $id = $account->id;

=head2 C<password>

    my $password = $account->password;

Return L<Yetie::Domain::Entity::Password> object.

=head2 C<created_at>

=head2 C<updated_at>

=head1 METHODS

L<Yetie::Domain::Entity::Account> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity::Password>, L<Yetie::Domain::Entity>
