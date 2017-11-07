package Yetie::Domain::Factory::Entity::Content;
use Mojo::Base 'Yetie::Domain::Factory';

1;
__END__

=head1 NAME

Yetie::Domain::Factory::Entity::Content

=head1 SYNOPSIS

    my $entity = Yetie::Domain::Factory::Entity::Content->new( %args )->create;

    # In controller
    my $entity = $c->factory('entity-content')->create(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Factory::Entity::Content> inherits all attributes from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Factory::Entity::Content> inherits all methods from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Domain::Factory>
