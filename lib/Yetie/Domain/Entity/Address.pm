package Yetie::Domain::Entity::Address;
use Yetie::Domain::Entity;

has line1       => '';
has line2       => '';
has level1      => '';
has level2      => '';
has postal_code => '';

sub hash_code {
    my $self  = shift;

    my $bytes;
    $bytes .= $self->$_ for qw(line1 line2 level1 level2 postal_code);
    $self->SUPER::hash_code($bytes);
}

1;
__END__

=head1 NAME

Yetie::Domain::Entity::Address

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::Address> inherits all attributes from L<Yetie::Domain::Entity> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Entity::Address> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>
