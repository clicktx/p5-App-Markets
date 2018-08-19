package Yetie::Domain::Entity::Emails;
use Yetie::Domain::Entity;

has email_list => sub { Yetie::Domain::Collection->new };

sub each { shift->email_list->each(@_) }

sub primary {
    my $self = shift;

    my $primary;
    $self->each( sub { $primary = $_ if $_->is_primary } );
    return $primary;
}

1;
__END__

=head1 NAME

Yetie::Domain::Entity::Emails

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::Emails> inherits all attributes from L<Yetie::Domain::Entity::Page> and implements
the following new ones.

=head2 C<email_list>

    my $collection = $emails->email_list;

Return L<Yetie::Domain::Collection> object.

Collection is an array composed of L<Yetie::Domain::Value::Email>.

=head1 METHODS

L<Yetie::Domain::Entity::Emails> inherits all methods from L<Yetie::Domain::Entity::Page> and implements
the following new ones.

=head2 C<each>

    $emails->each(...);

    # Longer version
    $emails->email_list->each(...);

=head2 C<primary>

    my $primary_email = $emails->primary;

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Value::Email>, L<Yetie::Domain::Entity>