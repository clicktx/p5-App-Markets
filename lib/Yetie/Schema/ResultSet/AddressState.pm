package Yetie::Schema::ResultSet::AddressState;
use Mojo::Base 'Yetie::Schema::ResultSet';

sub to_array_name_code_pair {
    my $self = shift;

    my @array;
    $self->each( sub { push @array, [ $_->name => $_->code ] } );
    return wantarray ? @array : \@array;
}

1;
__END__
=encoding utf8

=head1 NAME

Yetie::Schema::ResultSet::AddressState

=head1 SYNOPSIS

    my $result = $schema->resultset('AddressState')->method();

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Schema::ResultSet::AddressState> inherits all attributes from L<Yetie::Schema::ResultSet> and implements
the following new ones.

=head1 METHODS

L<Yetie::Schema::ResultSet::AddressState> inherits all methods from L<Yetie::Schema::ResultSet> and implements
the following new ones.

=head2 C<to_array_name_code_pair>

    # Return array
    my @countries = $resultset->to_array_name_code_pair();

    # Return array reference
    my $countries = $resultset->to_array_name_code_pair();

    # ( [ 'Country Name' => 'Country Code' ], [ Japan => 'JP' ] , ... )

Return Array or Array reference.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Schema::ResultSet>, L<Yetie::Schema>
