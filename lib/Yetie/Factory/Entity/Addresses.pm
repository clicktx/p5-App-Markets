package Yetie::Factory::Entity::Addresses;
use Mojo::Base 'Yetie::Factory';

sub cook {
    my $self = shift;

    $self->aggregate_collection( list => 'entity-address', $self->param('list') || [] );
}


1;
__END__

=head1 NAME

Yetie::Factory::Entity::Addresses

=head1 SYNOPSIS

    my $entity = Yetie::Factory::Entity::Addresses->new( %args )->construct();

    # In controller
    my $entity = $c->factory('entity-addresses')->construct(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Factory::Entity::Addresses> inherits all attributes from L<Yetie::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Factory::Entity::Addresses> inherits all methods from L<Yetie::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Factory>
