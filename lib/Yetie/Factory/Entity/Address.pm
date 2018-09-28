package Yetie::Factory::Entity::Address;
use Mojo::Base 'Yetie::Factory';

1;
__END__

=head1 NAME

Yetie::Factory::Entity::Address

=head1 SYNOPSIS

    my $entity = Yetie::Factory::Entity::Address->new( %args )->construct();

    # In controller
    my $entity = $c->factory('entity-address')->construct(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Factory::Entity::Address> inherits all attributes from L<Yetie::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Factory::Entity::Address> inherits all methods from L<Yetie::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Factory>
