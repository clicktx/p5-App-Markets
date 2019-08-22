package Yetie::Schema::ResultSet::CommonTaxRule;
use Mojo::Base 'Yetie::Schema::ResultSet';

sub find_by_dt {
    my ( $self, $dt ) = @_;

    my $tax_rules = $self->search(
        {
            start_at => { '<=' => $dt }
        },
        {
            prefetch => 'tax_rule',
            order_by => { -desc => 'start_at' },
        }
    );
    return $tax_rules->first;
}

sub find_now {
    my $self = shift;

    my $now = $self->app->date_time->now;
    return $self->find_by_dt($now);
}

1;
__END__
=encoding utf8

=head1 NAME

Yetie::Schema::ResultSet::CommonTaxRule

=head1 SYNOPSIS

    my $result = $schema->resultset('CommonTaxRule')->method();

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Schema::ResultSet::CommonTaxRule> inherits all attributes from L<Yetie::Schema::ResultSet> and implements
the following new ones.

=head1 METHODS

L<Yetie::Schema::ResultSet::CommonTaxRule> inherits all methods from L<Yetie::Schema::ResultSet> and implements
the following new ones.

=head2 C<find_by_dt>

    my $result = $rs->find_by_dt($DateTimeObject);

Return L<Yetie::Schema::Result::CommonTaxRule> object or C<undef>.

=head2 C<find_now>

    my $result = $rs->find_now;

    # Longer version
    my $result = $rs->find_by_dt( DateTime->now(...) );

See L</find_by_dt>

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Schema::ResultSet>, L<Yetie::Schema>
