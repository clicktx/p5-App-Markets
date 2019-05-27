package Yetie::Domain::Entity::Staff;
use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::MooseEntity';

has login_id   => ( is => 'ro' );
has created_at => ( is => 'ro' );
has updated_at => ( is => 'ro' );
has password   => (
    is      => 'ro',
    default => sub { __PACKAGE__->factory('value-password')->construct() }
);

sub is_staff { return shift->id ? 1 : 0 }

no Moose;
__PACKAGE__->meta->make_immutable;

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

Return C<LoginID>.

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

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Value::Password>, L<Yetie::Domain::Entity>
