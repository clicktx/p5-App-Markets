package Markets::Addons;
use Mojo::Base 'Markets::EventEmitter';

use Mojo::Loader 'load_class';
use Mojo::Util qw/camelize/;
use constant { PRIORITY_DEFAULT => '100' };

has dir         => sub { shift->app->pref('addons_dir') };
has namespaces  => sub { [] };
has action_hook => sub { Markets::Addons::ActionHook->new };
has filter_hook => sub { Markets::Addons::FilterHook->new };
has [qw/app installed uploaded/];

sub init {
    my ( $self, $installed_addons ) = ( shift, shift // {} );
    $self->{installed}    = $installed_addons;
    $self->{uploaded}     = $self->_fetch_addons_dir;
    $self->{remove_hooks} = [];

    my $addons = $self->app->addons->installed;
    foreach my $addon_class_name ( keys %{$addons} ) {

        # Initialize routes
        $self->_init_routes($addon_class_name);

        # Register addon
        my $addon = $self->register_addon($addon_class_name);

        # Subscribe hooks
        $self->to_enable($addon_class_name) if $self->is_enabled($addon_class_name);
    }

    # Remove hooks
    $self->_remove_hooks;
}

sub is_enabled {
    my ( $self, $addon_class_name ) = @_;
    my $addons = $self->app->addons->installed;
    $addons->{$addon_class_name}->{is_enabled};
}

sub load_addon {
    my ( $self, $addon_class_name ) = @_;

    $self->_push_inc_path($addon_class_name) unless $addon_class_name->can('new');

    my $class = $addon_class_name =~ /^[a-z]/ ? camelize $addon_class_name : $addon_class_name;
    return $class->new( app => $self->app ) if _load_class($class);

    # Not found
    die qq{Addon "$addon_class_name" missing, maybe you need to install it?\n};
}

sub new {
    my $self = shift;
    $self = $self->SUPER::new(@_);
    Scalar::Util::weaken $self->{app};
    $self;
}

sub register_addon { shift->load_addon(shift)->setup( ref $_[0] ? $_[0] : {@_} ) }

sub subscribe_hooks {
    my ( $self, $addon_class_name ) = @_;
    my $hooks = $self->app->addons->installed->{$addon_class_name}->{hooks};
    foreach my $hook ( @{$hooks} ) {
        my $hook_type = $hook->{type};
        $self->$hook_type->on($hook);
    }
    $self->app->renderer->cache( Mojo::Cache->new );
}

sub to_enable {
    my ( $self, $addon_class_name ) = @_;

    # Add hooks into the App.
    $self->subscribe_hooks($addon_class_name);

    # Add routes in to the App.
    $self->_add_routes($addon_class_name);
}

sub to_disable {
    my ( $self, $addon_class_name ) = @_;

    # Remove hooks for App.
    $self->unsubscribe_hooks($addon_class_name);

    # Remove routes for App.
    $self->_remove_routes($addon_class_name);
}

sub unsubscribe_hooks {
    my ( $self, $addon_class_name ) = @_;
    my $hooks = $self->app->addons->installed->{$addon_class_name}->{hooks};
    foreach my $hook ( @{$hooks} ) {
        my $hook_type = $hook->{type};
        $self->$hook_type->unsubscribe( $hook->{name} => $hook );
    }
    $self->app->renderer->cache( Mojo::Cache->new );
}

sub _add_routes {
    my ( $self, $addon_class_name ) = @_;
    my $routes = $self->app->addons->installed->{$addon_class_name}->{routes};

    $self->app->routes->add_child($routes) if @{ $routes->children };
}

sub _fetch_addons_dir {
    my $self       = shift;
    my $addons_dir = $self->dir;
    my $rel_dir    = Mojo::File::path( $self->app->home, $addons_dir );
    my @all_dir    = Markets::Util::directories($rel_dir);
    my @addons     = map { "Markets::Addon::" . $_ } @all_dir;
    return Mojo::Collection->new(@addons);
}

sub _init_routes {
    my ( $self, $addon_class_name ) = @_;
    $self->app->addons->installed->{$addon_class_name}->{routes} =
      Mojolicious::Routes->new->name($addon_class_name);
}

sub _load_class {
    my $class = shift;
    return $class->isa('Markets::Addon')
      unless my $e = load_class $class;
    ref $e ? die $e : return undef;
}

sub _push_inc_path {
    my ( $self, $addon_class_name ) = @_;
    $addon_class_name =~ s/Markets::Addon:://;
    my $addons_dir = $self->dir;

    # TODO: testスクリプト用に$self->app->homeを渡す必要がある。
    my $path = Mojo::File::path( $self->app->home, $addons_dir, $addon_class_name, 'lib' )
      ->to_abs->to_string;
    push @INC, $path;
}

sub _remove_hooks {
    my $self = shift;
    my $remove_hooks = $self->{remove_hooks} || [];
    return unless @{$remove_hooks};

    foreach my $remove_hook ( @{$remove_hooks} ) {
        my $type        = $remove_hook->{type};
        my $hook        = $remove_hook->{hook};
        my $subscribers = $self->app->addons->$type->subscribers($hook);
        my $unsubscribers =
          [ grep { $_->{cb_fn_name} eq $remove_hook->{cb_fn_name} } @{$subscribers} ];

        map { $self->app->addons->$type->unsubscribe( $hook, $_ ) } @{$unsubscribers};
    }
}

sub _remove_routes {
    my ( $self, $addon_class_name ) = @_;
    my $routes = $self->app->routes->find($addon_class_name);

    if ( ref $routes ) {
        $routes->remove;
        $self->app->routes->cache( Mojo::Cache->new );
    }
}

###################################################
# Separate namespace
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

=head2 filter_hook

Markets::Addons::FilterHook object.

=head2 installed

    my $installed_addons = $addons->installed;

Return Hash ref.

=head2 uploaded

    my $uploaded = $addons->uploaded;

Return L<Mojo::Collection> object.

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

=head2 register_addon

    $addons->register_addon('Markets::Addons::MyAddon');

Load a addon from the configured by full module name and run register.

=head2 subscribe_hooks

    $addons->subscribe_hooks('Markets::Addon::MyAddon');

Subscribe to C<Markets::Addons::ActionHook> or C<Markets::Addons::FilterHook> event.

=head2 to_enable

    $addons->to_enable('Markets::Addon::MyAddon');

Change addon status to enable.

=head2 to_disable

    $addons->to_disable('Markets::Addon::MyAddon');

Change addon status to disable.

=head2 unsubscribe_hooks

    $addons->unsubscribe_hooks('Markets::Addon::MyAddon');

Unsubscribe to C<Markets::Addons::ActionHook> or C<Markets::Addons::FilterHook> event.

=head1 SEE ALSO

L<Markets::EventEmitter> L<Mojolicious::Plugins> L<Mojo::EventEmitter>

=cut
