package Yetie::Domain::Factory::Address;
use Mojo::Base 'Yetie::Domain::Factory';

sub cook {
    my $self = shift;

    $self->aggregate( phones => 'entity-address-phones', { list => $self->param('phones') || [] } );
}

1;
__END__

=head1 NAME

Yetie::Domain::Factory::Address

=head1 SYNOPSIS

    my $entity = Yetie::Domain::Factory::Address->new( %args )->create;

    # In controller
    my $entity = $c->factory('entity-address')->create(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Factory::Address> inherits all attributes from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Factory::Address> inherits all methods from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Domain::Factory>
