package Yetie::Domain::Entity::Staff;
use Yetie::Domain::Entity;
use Yetie::Domain::Entity::Password;

has login_id   => '';
has created_at => undef;
has updated_at => undef;
has password   => sub { Yetie::Domain::Entity::Password->new };

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

=head2 C<password>

    my $password = $staff->password;

Return L<Yetie::Domain::Entity::Password> object.

=head2 C<created_at>

=head2 C<updated_at>

=head1 METHODS

L<Yetie::Domain::Entity::Staff> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<clone>

    my $clone_entity = $staff->clone;

=head2 C<is_modified>

    my $bool = $staff->is_modified;

Return boolean value.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>, L<Yetie::Domain::Entity::Password>
