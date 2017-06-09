package Markets::Service::Preference;
use Mojo::Base 'Markets::Service';

sub create_entity {
    my $self = shift;
    my $result = $self->app->schema->resultset('Preference')->search( {} );

    my @items;
    while ( my $row = $result->next ) {
        my %data = $row->get_inflated_columns;
        push @items, ( $row->name => \%data );
    }
    return $self->app->factory('entity-preference')->create( { items => \@items } );
}

sub load {
    my $self = shift;
    my $pref = $self->create_entity;
    $self->app->defaults( 'markets.entity.preference' => $pref );
    return $pref;
}

1;
__END__

=head1 NAME

Markets::Service::Preference - Application Service Layer

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Service::Preference> inherits all attributes from L<Markets::Service> and implements
the following new ones.

=head1 METHODS

=head2 C<create_entity>

    my $preferences = $app->service('preference')->create_entity();

Return L<Markets::Domain::Entity::Preference> object.

=head2 C<load>

    $app->service('preference')->load();

    # Access
    my $pref_obj = $app->stash('markets.entity.preference');

Loading preference from DB.
And set application defaults 'markets.entity.preference' into C<Markets::Domain::Entity::Preference> object.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO
