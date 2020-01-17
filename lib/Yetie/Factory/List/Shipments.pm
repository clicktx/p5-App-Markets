package Yetie::Factory::List::Shipments;
use Mojo::Base 'Yetie::Factory';

sub cook {
    my $self = shift;

    $self->aggregate_domain_list('entity-shipment');
    return $self;
}

1;
__END__

=head1 NAME

Yetie::Factory::List::Shipments

=head1 SYNOPSIS

    my $list = Yetie::Factory::List::Shipments->new()->construct();

    # In controller
    my $list = $c->factory('list-shipments')->construct();

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Factory::List::Shipments> inherits all attributes from L<Yetie::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Factory::List::Shipments> inherits all methods from L<Yetie::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Factory>
