package Yetie::Factory::List::PaymentMethods;
use Mojo::Base 'Yetie::Factory';

sub cook {
    my $self = shift;

    $self->aggregate_collection( list => 'entity-payment_method', $self->param('list') || [] );
}

1;
__END__

=head1 NAME

Yetie::Factory::List::PaymentMethods

=head1 SYNOPSIS

    my $list = Yetie::Factory::List::PaymentMethods->new()->construct();

    # In controller
    my $list = $c->factory('list-payment_methods')->construct();

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Factory::List::PaymentMethods> inherits all attributes from L<Yetie::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Factory::List::PaymentMethods> inherits all methods from L<Yetie::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Factory>
