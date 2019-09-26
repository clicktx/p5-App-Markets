package Yetie::Factory::List::TotalAmounts;
use Mojo::Base 'Yetie::Factory';

sub cook {
    my $self = shift;

    # Aggregate shipments
    $self->aggregate_collection( list => 'entity-total_amount', $self->param('list') );
}

1;
__END__

=head1 NAME

Yetie::Factory::List::TotalAmounts

=head1 SYNOPSIS

    my $list = Yetie::Factory::List::TotalAmounts->new()->construct();

    # In controller
    my $list = $c->factory('list-total_amounts')->construct();

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Factory::List::TotalAmounts> inherits all attributes from L<Yetie::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Factory::List::TotalAmounts> inherits all methods from L<Yetie::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Factory>
