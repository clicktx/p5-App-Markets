package Markets::Domain::Factory::Entity::Content;
use Mojo::Base 'Markets::Domain::Factory';
use Markets::Domain::Collection qw/collection/;

sub cook {
    my $self = shift;

    # Aggregate breadcrumb
    $self->aggregate( breadcrumb => 'entity-breadcrumb', $self->param('breadcrumb') || [] );
}

1;
__END__

=head1 NAME

Markets::Domain::Factory::Entity::Content

=head1 SYNOPSIS

    my $entity = Markets::Domain::Factory::Entity::Content->new( %args )->create;

    # In controller
    my $entity = $c->factory('entity-content')->create(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Domain::Factory::Entity::Content> inherits all attributes from L<Markets::Domain::Factory> and implements
the following new ones.

=head1 METHODS

L<Markets::Domain::Factory::Entity::Content> inherits all methods from L<Markets::Domain::Factory> and implements
the following new ones.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

 L<Markets::Domain::Factory>
