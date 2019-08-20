package Yetie::Schema::ResultSet::CategoryTaxRule;
use Mojo::Base 'Yetie::Schema::ResultSet';

sub find_by_dt {
    my ( $self, $category, $dt ) = @_;

    my $tax_rules = $self->search(
        {
            root_id  => $category->root_id,
            lft      => { '<=' => $category->lft },
            rgt      => { '>=' => $category->rgt },
            start_at => { '<=' => $dt },
        },
        {
            prefetch => [qw/category tax_rule/],
            order_by => { -desc => [qw/level start_at/] },
        }
    );
    return $tax_rules->first;
}

sub find_now {
    my ( $self, $category ) = @_;

    my $now = $self->app->date_time->now;
    return $self->find_by_dt( $category, $now );
}

1;
__END__
=encoding utf8

=head1 NAME

Yetie::Schema::ResultSet::CategoryTaxRule

=head1 SYNOPSIS

    my $result = $schema->resultset('CategoryTaxRule')->method();

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Schema::ResultSet::CategoryTaxRule> inherits all attributes from L<Yetie::Schema::ResultSet> and implements
the following new ones.

=head1 METHODS

L<Yetie::Schema::ResultSet::CategoryTaxRule> inherits all methods from L<Yetie::Schema::ResultSet> and implements
the following new ones.

=head2 C<find_by_dt>

    my $result = $rs->find_by_dt( $category, $DateTimeObject );

Return L<Yetie::Schema::Result::CategoryTaxRule> object or C<undef>.

=head2 C<find_now>

    my $result = $rs->find_now( $category );

    # Longer version
    my $result = $rs->find_by_dt( $category , DateTime->now(...) );

See L</find_by_dt>

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Schema::ResultSet>, L<Yetie::Schema>
