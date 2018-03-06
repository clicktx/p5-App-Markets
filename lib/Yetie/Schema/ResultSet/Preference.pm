package Yetie::Schema::ResultSet::Preference;
use Mojo::Base 'Yetie::Schema::Base::ResultSet';

sub to_data {
    my $self = shift;

    my @properties;
    $self->each(
        sub {
            my $row  = shift;
            my %data = $row->get_inflated_columns;
            push @properties, { $row->name => \%data };
        }
    );
    return \@properties;
}

1;
__END__
=encoding utf8

=head1 NAME

Yetie::Schema::ResultSet::Preference

=head1 SYNOPSIS

    my $data = $schema->resultset('Preference')->method();

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Schema::ResultSet::Preference> inherits all attributes from L<Yetie::Schema::Base::ResultSet> and implements
the following new ones.

=head1 METHODS

L<Yetie::Schema::ResultSet::Preference> inherits all methods from L<Yetie::Schema::Base::ResultSet> and implements
the following new ones.

=head2 C<to_data>

    # [ { name => {...} }, { name2 => {...} }, ... ]
    $array_ref = $resultset->to_data();

Return Array refference.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Schema::Base::ResultSet>, L<Yetie::Schema>
