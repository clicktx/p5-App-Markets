package Yetie::Factory::Entity::Activity;
use Mojo::Base 'Yetie::Factory';

1;
__END__

=head1 NAME

Yetie::Factory::Entity::Activity

=head1 SYNOPSIS

    my $entity = Yetie::Factory::Entity::Activity->new( %args )->construct();

    # In controller
    my $entity = $c->factory('entity-activity')->construct(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Factory::Entity::Activity> inherits all attributes from L<Yetie::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Factory::Entity::Activity> inherits all methods from L<Yetie::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Factory>
