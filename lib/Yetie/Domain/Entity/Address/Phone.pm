package Yetie::Domain::Entity::Address::Phone;
use Yetie::Domain::Entity;

has number => '';
has type   => '';

sub number_only {
    local $_ = shift->number;
    s/\D//g;
    $_;
}

1;
__END__

=head1 NAME

Yetie::Domain::Entity::Address::Phone

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::Address::Phone> inherits all attributes from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<number>

=head2 C<type>

=head1 METHODS

L<Yetie::Domain::Entity::Address::Phone> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<number_only>

    my $number_only = $phone->number_only;

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>
