package Yetie::Factory::List::SalesItems;
use Mojo::Base 'Yetie::Factory';

sub cook {
    my $self = shift;

    # Aggregate items
    $self->aggregate_collection( list => 'entity-order_line_item', $self->param('list') );
}

1;
__END__

=head1 NAME

Yetie::Factory::List::SalesItems

=head1 SYNOPSIS

    my $list = Yetie::Factory::List::SalesItems->new()->construct();

    # In controller
    my $list = $c->factory('list-sales_items')->construct();

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Factory::List::SalesItems> inherits all attributes from L<Yetie::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Factory::List::SalesItems> inherits all methods from L<Yetie::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Factory>
