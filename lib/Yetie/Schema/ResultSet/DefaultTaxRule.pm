package Yetie::Schema::ResultSet::DefaultTaxRule;
use Mojo::Base 'Yetie::Schema::ResultSet';

sub find_by_dt {
    my ( $self, $dt ) = @_;

    my $default_tax_rules = $self->search(
        {
            start_at => { '<=' => $dt }
        },
        {
            prefetch => 'tax_rule',
            order_by => { -desc => 'start_at' },
        }
    );
    return $default_tax_rules->first;
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

Yetie::Schema::ResultSet::DefaultTaxRule

=head1 SYNOPSIS

    my $result = $schema->resultset('DefaultTaxRule')->method();

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Schema::ResultSet::DefaultTaxRule> inherits all attributes from L<Yetie::Schema::ResultSet> and implements
the following new ones.

=head1 METHODS

L<Yetie::Schema::ResultSet::DefaultTaxRule> inherits all methods from L<Yetie::Schema::ResultSet> and implements
the following new ones.

=head2 C<find_by_dt>

    my $result = $rs->find_by_dt($DateTimeObject);

Return L<Yetie::Schema::Result::DefaultTaxRule> object or C<undef>.

=head2 C<find_now>

    my $result = $rs->find_now;

    # Longer version
    my $result = $rs->find_by_dt( DateTime->now(...) );

See L</find_by_dt>

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Schema::ResultSet>, L<Yetie::Schema>
