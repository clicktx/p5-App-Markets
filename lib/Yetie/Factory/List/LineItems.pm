package Yetie::Factory::List::LineItems;
use Mojo::Base 'Yetie::Factory';

sub cook {
    my $self = shift;

    # Aggregate items
    $self->aggregate_collection( list => 'entity-line_item', $self->param('list') );
}

1;
__END__

=head1 NAME

Yetie::Factory::List::LineItems

=head1 SYNOPSIS

    my $list = Yetie::Factory::List::LineItems->new()->construct();

    # In controller
    my $list = $c->factory('list-line_items')->construct();

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Factory::List::LineItems> inherits all attributes from L<Yetie::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Factory::List::LineItems> inherits all methods from L<Yetie::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Factory>
