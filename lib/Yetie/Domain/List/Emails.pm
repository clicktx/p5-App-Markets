package Yetie::Domain::List::Emails;
use Yetie::Domain::Base 'Yetie::Domain::List';

sub primary {
    my $self = shift;

    my $primary;
    $self->each( sub { $primary = $_ if $_->is_primary } );
    return $primary;
}

1;
__END__

=head1 NAME

Yetie::Domain::List::Emails

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::List::Emails> inherits all attributes from L<Yetie::Domain::List> and implements
the following new ones.

=head2 C<list>

    my $collection = $emails->list;

Return L<Yetie::Domain::Collection> object.

Collection is an array composed of L<Yetie::Domain::Value::Email>.

=head1 METHODS

L<Yetie::Domain::List::Emails> inherits all methods from L<Yetie::Domain::List> and implements
the following new ones.

=head2 C<primary>

    my $primary_email = $emails->primary;

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::List>, L<Yetie::Domain::Value::Email>
