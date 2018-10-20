package Yetie::Service::Preference;
use Mojo::Base 'Yetie::App::Core::Service';
use Try::Tiny;

sub load {
    my $self = shift;

    my $properties = $self->resultset('Preference')->search( {} )->to_data;
    my $pref = $self->factory('set-preferences')->construct( hash_set => $properties );
    $self->app->cache( preferences => $pref );

    $self->app->log->debug( 'Loading preferences from DB via ' . __PACKAGE__ );
    return $pref;
}

sub store {
    my $self = shift;

    my $pref = $self->app->cache('preferences');
    return unless $pref->is_modified;

    my $cb = sub {
        $pref->properties->each(
            sub {
                $self->resultset('Preference')->find( $b->id )->update( { value => $b->value } ) if $b->is_modified;
            }
        );
    };

    try { $self->schema->txn_do($cb) }
    catch { $self->app->logging('error')->error('pref.update.failed'); return };

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

L<Yetie::Service::Preference> inherits all attributes from L<Yetie::App::Core::Service> and implements
the following new ones.

=head1 METHODS

L<Yetie::Service::Preference> inherits all methods from L<Yetie::App::Core::Service> and implements
the following new ones.

=head2 C<load>

    $app->service('preference')->load();

    # Access
    my $pref_obj = $app->stash('yetie.entity.preference');

Loading preference from DB.
And set application defaults 'yetie.entity.preference' into C<Yetie::Domain::Entity::Preference> object.

=head2 C<store>

    $app->service('preference')->store();

Store the data into database, if C<is_modified> is true.
Updates are modified data only.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::App::Core::Service>
