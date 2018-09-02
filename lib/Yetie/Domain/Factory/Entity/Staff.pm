package Yetie::Domain::Factory::Entity::Staff;
use Mojo::Base 'Yetie::Domain::Factory';

sub cook {
    my $self = shift;

    # password
    $self->aggregate( password => 'value-password', $self->{password} || {} );
}

1;
__END__

=head1 NAME

Yetie::Domain::Factory::Entity::Staff

=head1 SYNOPSIS

    my $entity = Yetie::Domain::Factory::Entity::Staff->new( %args )->create;

    # In controller
    my $entity = $c->factory('entity-staff')->create(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Factory::Entity::Staff> inherits all attributes from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Factory::Entity::Staff> inherits all methods from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Domain::Factory>
