package Markets::Addons;
use Mojo::Base 'Markets::EventEmitter';

use Carp qw/croak/;
use Mojo::Home;
use Mojo::File;
use Mojo::Loader 'load_class';
use Mojo::Util qw/camelize decamelize/;
use Mojo::Cache;
use Mojolicious::Routes;
use Markets::Util;
use constant { PRIORITY_DEFAULT => '100' };

has dir         => sub { shift->app->pref('addons_dir') };
has namespaces  => sub { [] };
has action_hook => sub { Markets::Addons::ActionHook->new };
has filter_hook => sub { Markets::Addons::FilterHook->new };
has 'app';

sub _on { shift->on(@_) }

sub get_all {
    my $self       = shift;
    my $addons_dir = $self->dir;
    my $rel_dir    = Mojo::Home->new( $self->app->home )->rel_dir($addons_dir);
    my @all_dir    = Markets::Util::directories($rel_dir);
    my @all_addons = map { "Markets::Addon::" . $_ } @all_dir;
    return wantarray ? @all_addons : \@all_addons;
}

sub is_enabled {
    my ( $self, $addon_name ) = @_;
    my $addons = $self->app->stash('addons');
    $addons->{$addon_name}->{is_enabled};
}

sub init {
    my ( $self, $addon_settings ) = ( shift, shift // {} );
    my $app = $self->app;
    $app->defaults( addons => $addon_settings, remove_hooks => [] );

    my $addons = $app->stash('addons');
    foreach my $addon_name ( keys %{$addons} ) {

        # Initialize routes
        $self->_init_routes($addon_name);

        # Register addon
        $app->register_addon($addon_name);

        # Subscribe hooks
        $self->to_enable($addon_name) if $self->is_enabled($addon_name);
    }

    # Remove hooks
    $self->_remove_hooks;
}

sub _remove_hooks {
    my $self = shift;
    my $remove_hooks = $self->app->stash('remove_hooks') || '';
    return unless $remove_hooks;

    foreach my $remove_hook ( @{$remove_hooks} ) {
        my $type        = $remove_hook->{type};
        my $hook        = $remove_hook->{hook};
        my $subscribers = $self->app->addons->$type->subscribers($hook);
        my $unsubscribers =
          [ grep { $_->{cb_fn_name} eq $remove_hook->{cb_fn_name} } @{$subscribers} ];

        map { $self->app->addons->$type->unsubscribe( $hook, $_ ) } @{$unsubscribers};
    }
}

sub _init_routes {
    my ( $self, $name ) = @_;
    $self->app->stash('addons')->{$name}->{routes} =
      Mojolicious::Routes->new->name($name);
}

sub to_enable {
    my ( $self, $addon_name ) = @_;

    # Add hooks into the App.
    $self->subscribe_hooks($addon_name);

    # Add routes in to the App.
    $self->_add_routes($addon_name);
}

sub to_disable {
    my ( $self, $addon_name ) = @_;

    # Remove hooks for App.
    $self->unsubscribe_hooks($addon_name);

    # Remove routes for App.
    $self->_remove_routes($addon_name);
}

sub subscribe_hooks {
    my ( $self, $addon_name ) = @_;
    my $hooks = $self->app->stash('addons')->{$addon_name}->{hooks};
    foreach my $hook ( @{$hooks} ) {
        my $hook_type = $hook->{type};
        $self->$hook_type->_on($hook);
    }
    $self->app->renderer->cache( Mojo::Cache->new );
}

sub unsubscribe_hooks {
    my ( $self, $addon_name ) = @_;
    my $hooks = $self->app->stash('addons')->{$addon_name}->{hooks};
    foreach my $hook ( @{$hooks} ) {
        my $hook_type = $hook->{type};
        $self->$hook_type->unsubscribe( $hook->{name} => $hook );
    }
    $self->app->renderer->cache( Mojo::Cache->new );
}

sub _add_routes {
    my ( $self, $addon_name ) = @_;
    my $routes = $self->app->stash('addons')->{$addon_name}->{routes};

    $self->app->routes->add_child($routes) if @{ $routes->children };
}

sub _remove_routes {
    my ( $self, $addon_name ) = @_;
    my $routes = $self->app->routes->find($addon_name);

    if ( ref $routes ) {
        $routes->remove;
        $self->app->routes->cache( Mojo::Cache->new );
    }
}

sub _push_inc_path {
    my ( $self, $name ) = @_;
    $name =~ s/Markets::Addon:://;
    my $addons_dir = $self->dir;

    # TODO: testスクリプト用に$self->app->homeを渡す必要がある。
    my $path = Mojo::File::path( $self->app->home, $addons_dir, $name, 'lib' )->to_abs->to_string;
    push @INC, $path;
}

###################################################
###  loading plugin code from Mojolicous::Plugins
###################################################
sub load_addon {
    my ( $self, $name ) = @_;

    # Try all namespaces and full module name
    # The Markets addon use full module name only!
    $self->_push_inc_path($name) unless $name->can('new');

    my $suffix = $name =~ /^[a-z]/ ? camelize $name : $name;
    my @classes = map { "${_}::$suffix" } @{ $self->namespaces };
    for my $class ( @classes, $name ) {
        return $class->new( app => $self->app ) if _load($class);
    }

    # Not found
    die qq{Addon "$name" missing, maybe you need to install it?\n};
}

sub register_addon {
    shift->load_addon(shift)->init( ref $_[0] ? $_[0] : {@_} );
}

sub _load {
    my $module = shift;
    return $module->isa('Markets::Addon')
      unless my $e = load_class $module;
    ref $e ? die $e : return undef;
}

###################################################

# Use separate namespace
package Markets::Addons::ActionHook;
use Mojo::Base 'Markets::Addons';
sub emit { shift->SUPER::emit(@_) }

package Markets::Addons::FilterHook;
use Mojo::Base 'Markets::Addons';
sub emit { shift->SUPER::emit(@_) }

1;

=encoding utf8

=head1 NAME

Markets::Addons - Addon manager for Markets

=head1 SYNOPSIS


=head1 DESCRIPTION

L<Markets::Addons> is L<Mojolicious::Plugins> Based.
This module is addon maneger of Markets.

=head1 EVENTS

L<Markets::Addons> inherits all events from L<Mojo::EventEmitter> & L<Markets::EventEmitter>.

=head1 ATTRIBUTES

=head2 app

    my $app = $addons->app;

Return the application object.

=head2 action_hook

Markets::Addons::ActionHook object.

=head2 filter

Markets::Addons::FilterHook object.

=head1 METHODS

=head2 emit

    # Emit action hook
    $addons->action_hook->emit('foo');
    $addons->action_hook->emit(foo => 123);

    # Emit filter hook
    $addons->filter_hook->emit('foo');
    $addons->filter_hook->emit(foo => 123);

Emit event as action/filter hook.
This method is Markets::Addons::ActionHook::emit or Markets::Addons::FilterHook::emit.

=head2 init

    $addons->init(\%addon_settings);

=head2 get_all

    # Ref
    my $all_addons = $addons->get_all;
    # Array
    my @all_addons = $addons->get_all;

=head2 to_enable

    $addons->to_enable('Markets::Addon::MyAddon');

Change addon status to enable.

=head2 to_disable

    $addons->to_disable('Markets::Addon::MyAddon');

Change addon status to disable.

=head2 subscribe_hooks

    $addons->subscribe_hooks('Markets::Addon::MyAddon');

Subscribe to C<Markets::Addons::ActionHook> or C<Markets::Addons::FilterHook> event.

=head2 unsubscribe_hooks

    $addons->unsubscribe_hooks('Markets::Addon::MyAddon');

Unsubscribe to C<Markets::Addons::ActionHook> or C<Markets::Addons::FilterHook> event.

=head2 register_addon

    $addons->register_addon('Markets::Addons::MyAddon');

Load a addon from the configured by full module name and run register.

=head1 SEE ALSO

L<Markets::EventEmitter> L<Mojolicious::Plugins> L<Mojo::EventEmitter>

=cut
