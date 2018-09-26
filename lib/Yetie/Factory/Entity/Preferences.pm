package Yetie::Factory::Entity::Preferences;
use Mojo::Base 'Yetie::Factory';

sub cook {
    my $self = shift;

    # Aggregate properties
    $self->aggregate_ixhash( hash_set => 'entity-preference-property', $self->param('hash_set') || [] );
}

1;
__END__

=head1 NAME

Yetie::Factory::Entity::Preferences

=head1 SYNOPSIS

    my $entity = Yetie::Factory::Entity::Preferences->new( %args )->construct();

    # In controller
    my $entity = $c->factory('entity-preferences')->construct(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Factory::Entity::Preferences> inherits all attributes from L<Yetie::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Factory::Entity::Preferences> inherits all methods from L<Yetie::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Factory>