package Yetie::Service::Tax;
use Mojo::Base 'Yetie::Service';

sub get_rule {
    my $self = shift;
    my $date_time = shift || $self->app->date_time->now;

    my $scheme = $self->resultset('CommonTaxRule');
    my $rs     = $scheme->search(
        {
            start_at => { '<=' => $date_time }
        },
        {
            order_by => { -desc => 'start_at' },
            prefetch => 'tax_rule',
        }
    )->limit(1);

    my $result_rule = $rs->first->tax_rule;
    my $tax_rule    = $self->factory('entity-tax_rule')->construct( $result_rule->to_data );
    return $tax_rule;
}

1;
__END__

=head1 NAME

Yetie::Service::Tax

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Service::Tax> inherits all attributes from L<Yetie::Service> and implements
the following new ones.

=head1 METHODS

L<Yetie::Service::Tax> inherits all methods from L<Yetie::Service> and implements
the following new ones.

=head2 C<get_rule>

    # Default DateTime->now
    my $tax_rule = $service->get_rule();

    my $tax_rule = $service->get_rule($DateTimeObject);

    my $tax_rule = $service->get_rule('2019-10-25');

Return L<Yetie::Domain::Entity::TaxRule> object.

Get the current time, if no arguments.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
