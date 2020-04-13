package Yetie::Schema::ResultSet::AddressContinent;
use Mojo::Base 'Yetie::Schema::ResultSet';

sub get_countries {
    my ( $self, $where ) = ( shift, shift || {} );

    return $self->search(
        $where,
        {
            prefetch => 'countries',
            order_by => [ 'me.position', 'countries.position' ],
        }
    );
}

1;
__END__
=encoding utf8

=head1 NAME

Yetie::Schema::ResultSet::AddressContinent

=head1 SYNOPSIS

    my $result = $schema->resultset('AddressContinent')->method();

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Schema::ResultSet::AddressContinent> inherits all attributes from L<Yetie::Schema::ResultSet> and implements
the following new ones.

=head1 METHODS

L<Yetie::Schema::ResultSet::AddressContinent> inherits all methods from L<Yetie::Schema::ResultSet> and implements
the following new ones.

=head2 C<get_countries>

    $resultset->get_countries( \%where );

Return L<Yetie::Schema::ResultSet::AddressContinent>

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Schema::ResultSet>, L<Yetie::Schema>
