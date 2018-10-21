package Yetie::Factory::Set::Preferences;
use Mojo::Base 'Yetie::Factory';

sub cook {
    my $self = shift;

    # Aggregate properties
    $self->aggregate_ixhash( hash_set => 'entity-preference-property', $self->param('hash_set') || [] );
}

1;
__END__

=head1 NAME

Yetie::Factory::Set::Preferences

=head1 SYNOPSIS

    my $entity = Yetie::Factory::Set::Preferences->new( %args )->construct();

    # In controller
    my $entity = $c->factory('set-preferences')->construct(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Factory::Set::Preferences> inherits all attributes from L<Yetie::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Factory::Set::Preferences> inherits all methods from L<Yetie::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Factory>
