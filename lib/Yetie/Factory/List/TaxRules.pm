package Yetie::Factory::List::TaxRules;
use Mojo::Base 'Yetie::Factory';

sub cook {
    my $self = shift;

    $self->aggregate_collection( list => 'entity-tax_rule', $self->param('list') || [] );
}

1;
__END__

=head1 NAME

Yetie::Factory::List::TaxRules

=head1 SYNOPSIS

    my $list = Yetie::Factory::List::TaxRules->new()->construct();

    # In controller
    my $list = $c->factory('list-tax_rules')->construct();

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Factory::List::TaxRules> inherits all attributes from L<Yetie::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Factory::List::TaxRules> inherits all methods from L<Yetie::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Factory>
