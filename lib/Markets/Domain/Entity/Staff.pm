package Markets::Domain::Entity::Staff;
use Markets::Domain::Entity;
use Markets::Domain::Entity::Password;

has login_id   => '';
has created_at => undef;
has updated_at => undef;
has password   => sub { Markets::Domain::Entity::Password->new };

1;
__END__

=head1 NAME

Markets::Domain::Entity::Staff

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Domain::Entity::Staff> inherits all attributes from L<Markets::Domain::Entity> and implements
the following new ones.

=head2 C<id>

    my $id = $staff->id;

=head2 C<password>

    my $password = $staff->password;

Return L<Markets::Domain::Entity::Password> object.

=head2 C<created_at>

=head2 C<updated_at>

=head1 METHODS

L<Markets::Domain::Entity::Staff> inherits all methods from L<Markets::Domain::Entity> and implements
the following new ones.

=head2 C<clone>

    my $clone_entity = $staff->clone;

=head2 C<is_modified>

    my $bool = $staff->is_modified;

Return boolean value.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Domain::Entity>, L<Markets::Domain::Entity::Password>
