package Yetie::Domain::Entity::Customer;
use Yetie::Domain::Entity;
use Yetie::Domain::Entity::Password;

has password_id => 0;
has created_at  => undef;
has updated_at  => undef;
has password    => sub { __PACKAGE__->factory('entity-password') };
has emails      => sub { Yetie::Domain::Collection->new };

1;
__END__

=head1 NAME

Yetie::Domain::Entity::Customer

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::Customer> inherits all attributes from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<created_at>

=head2 C<emails>

    my $emails = $customer->emails;
    $emails->each( sub { ... } );

Return L<Yetie::Domain::Collection> object.
Elements is L<Yetie::Domain::Entity::Email> object.

=head2 C<id>

    my $id = $customer->id;

=head2 C<password_id>

=head2 C<password>

    my $password = $customer->password;

Return L<Yetie::Domain::Entity::Password> object.

=head2 C<updated_at>

=head1 METHODS

L<Yetie::Domain::Entity::Customer> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<clone>

    my $clone_entity = $customer->clone;

=head2 C<is_modified>

    my $bool = $customer->is_modified;

Return boolean value.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>, L<Yetie::Domain::Collection>, L<Yetie::Domain::Entity::Password>
