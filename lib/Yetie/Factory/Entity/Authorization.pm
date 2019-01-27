package Yetie::Factory::Entity::Authorization;
use Mojo::Base 'Yetie::Factory';

sub cook {
    my $self = shift;

    # token
    $self->aggregate( token => 'value-token', $self->{token} );

    # email
    $self->aggregate( email => 'value-email', $self->{email} );

    # expires
    $self->aggregate( expires => 'value-expires', $self->{expires} );
}

1;
__END__

=head1 NAME

Yetie::Factory::Entity::Authorization

=head1 SYNOPSIS

    my $entity = Yetie::Factory::Entity::Authorization->new( %args )->construct();

    # In controller
    my $entity = $c->factory('entity-authorization')->construct(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Factory::Entity::Authorization> inherits all attributes from L<Yetie::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Factory::Entity::Authorization> inherits all methods from L<Yetie::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Factory>
