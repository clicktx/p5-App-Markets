package Yetie::Factory::List::Shippings;
use Mojo::Base 'Yetie::Factory';

sub cook {
    my $self = shift;

    $self->aggregate_domain_list('entity-shipping');
    return $self;
}

1;
__END__

=head1 NAME

Yetie::Factory::List::Shippings

=head1 SYNOPSIS

    my $list = Yetie::Factory::List::Shippings->new()->construct();

    # In controller
    my $list = $c->factory('list-shippings')->construct();

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Factory::List::Shippings> inherits all attributes from L<Yetie::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Factory::List::Shippings> inherits all methods from L<Yetie::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Factory>
