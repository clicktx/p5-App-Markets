package Yetie::Domain::Factory::Address::Phones;
use Mojo::Base 'Yetie::Domain::Factory';

sub cook {
    my $self = shift;

    $self->aggregate_collection( list => 'entity-address-phone', $self->param('phones') || [] );
}

1;
__END__

=head1 NAME

Yetie::Domain::Factory::Address::Phones

=head1 SYNOPSIS

    my $entity = Yetie::Domain::Factory::Address::Phones->new( %args )->create;

    # In controller
    my $entity = $c->factory('entity-address-phones')->create(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Factory::Address::Phones> inherits all attributes from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Factory::Address::Phones> inherits all methods from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Domain::Factory>
