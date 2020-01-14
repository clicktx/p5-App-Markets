package Yetie::Factory::Entity::Auth;
use Mojo::Base 'Yetie::Factory';

sub cook {
    my $self = shift;

    # token
    $self->aggregate( token => 'value-token' );

    # email
    $self->aggregate( email => 'value-email' );

    # expires
    $self->aggregate( expires => 'value-expires' );
}

1;
__END__

=head1 NAME

Yetie::Factory::Entity::Auth

=head1 SYNOPSIS

    my $entity = Yetie::Factory::Entity::Auth->new( %args )->construct();

    # In controller
    my $entity = $c->factory('entity-auth')->construct(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Factory::Entity::Auth> inherits all attributes from L<Yetie::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Factory::Entity::Auth> inherits all methods from L<Yetie::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Factory>
