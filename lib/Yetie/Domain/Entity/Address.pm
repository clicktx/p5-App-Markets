package Yetie::Domain::Entity::Address;
use Yetie::Domain::Entity;

has hash          => '';
has line1         => '';
has line2         => '';
has level1        => '';
has level2        => '';
has postal_code   => '';
has personal_name => '';
has company_name  => '';
has phone         => '';
has fax           => '';
has mobile        => '';

sub hash_code {
    my $self = shift;

    my $bytes;
    $bytes .= $self->$_ for qw(
      line1 line2 level1 level2 postal_code personal_name company_name
    );
    $self->SUPER::hash_code($bytes);
}

sub to_data {
    my $self = shift;
    my $data = $self->SUPER::to_hash;

    $data->{hash} = $self->hash_code;
    return $data;
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
