package Markets::Service::Preference;
use Mojo::Base 'Markets::Service';
use Try::Tiny;

my $stash_key = 'markets.entity.preference';
has resultset => sub { shift->schema->resultset('Preference') };

sub load {
    my $self = shift;
    my $pref = $self->_create_entity;
    $self->app->defaults( $stash_key => $pref );

    $self->app->log->debug( 'Loading preferences from DB via ' . __PACKAGE__ );
    return $pref;
}

sub store {
    my $self = shift;

    my $pref = $self->app->stash($stash_key);
    return unless $pref->is_modified;

    my $cb = sub {
        $pref->items->each(
            sub {
                $self->resultset->find( $b->id )->update( { value => $b->value } ) if $b->is_modified;
            }
        );
    };

    try { $self->schema->txn_do($cb) }
    catch { $self->app->error_log->error("Don't update preference. "); return };

    $pref->reset_modified;
    return 1;
}

sub _create_entity {
    my $self = shift;
    my $itr = $self->resultset->search( {} );

    my @items;
    $itr->each(
        sub {
            my $row  = shift;
            my %data = $row->get_inflated_columns;
            push @items, ( $row->name => \%data );
        }
    );
    return $self->app->factory('entity-preference')->create( { items => \@items } );
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

L<Markets::Service::Preference> inherits all methods from L<Markets::Service> and implements
the following new ones.

=head2 C<load>

    $app->service('preference')->load();

    # Access
    my $pref_obj = $app->stash('markets.entity.preference');

Loading preference from DB.
And set application defaults 'markets.entity.preference' into C<Markets::Domain::Entity::Preference> object.

=head2 C<store>

    $app->service('preference')->store();

Store the data into database, if C<is_modified> is ture.
Updates are modified data only.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Service>
