package Yetie::Service::Preference;
use Mojo::Base 'Yetie::Service';
use Try::Tiny;

has resultset => sub { shift->schema->resultset('Preference') };
my $stash_key = 'yetie.entity.preference';

sub load {
    my $self = shift;

    my $properties = $self->resultset->search( {} )->to_data;
    my $pref = $self->factory('preference')->create( properties => $properties );
    $self->app->defaults( $stash_key => $pref );

    $self->app->log->debug( 'Loading preferences from DB via ' . __PACKAGE__ );
    return $pref;
}

sub store {
    my $self = shift;

    my $pref = $self->app->stash($stash_key);
    return unless $pref->is_modified;

    my $cb = sub {
        $pref->properties->each(
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

1;
__END__

=head1 NAME

Yetie::Service::Preference - Application Service Layer

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Service::Preference> inherits all attributes from L<Yetie::Service> and implements
the following new ones.

=head1 METHODS

L<Yetie::Service::Preference> inherits all methods from L<Yetie::Service> and implements
the following new ones.

=head2 C<load>

    $app->service('preference')->load();

    # Access
    my $pref_obj = $app->stash('yetie.entity.preference');

Loading preference from DB.
And set application defaults 'yetie.entity.preference' into C<Yetie::Domain::Entity::Preference> object.

=head2 C<store>

    $app->service('preference')->store();

Store the data into database, if C<is_modified> is ture.
Updates are modified data only.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
