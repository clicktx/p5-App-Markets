package Markets::Domain::Entity::Customer;
use Markets::Domain::Entity;
use Markets::Domain::Collection;
use Markets::Domain::Entity::Password;

has [qw/id created_at updated_at/];
has password => sub { Markets::Domain::Entity::Password->new };
has emails   => sub { Markets::Domain::Collection->new };

1;
__END__

=head1 NAME

Markets::Domain::Entity::Customer

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Domain::Entity::Customer> inherits all attributes from L<Markets::Domain::Entity> and implements
the following new ones.

=head2 C<emails>

    my $emails = $customer->emails;
    $emails->each( sub { ... } );

Return L<Markets::Domain::Collection> object.
Elements is L<Markets::Domain::Entity::Email> object.

=head2 C<id>

=head2 C<password>

    my $password = $customer->password;

Return L<Markets::Domain::Entity::Password> object.

=head1 METHODS

L<Markets::Domain::Entity::Customer> inherits all methods from L<Markets::Domain::Entity> and implements
the following new ones.

=head2 C<clone>

=head2 C<is_modified>

    my $bool = $customer->is_modified;

Return boolean value.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

 L<Markets::Domain::Entity>
