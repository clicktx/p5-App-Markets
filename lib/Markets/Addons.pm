package Markets::Addons;
use Mojo::Base 'Markets::EventEmitter';

use Mojo::Loader 'load_class';
use Mojo::Util qw/camelize decamelize/;
use constant {
    DEFAULT_PRIORITY => '100',
    ADDON_NAME_SPACE => 'Markets::Addon',
};

has dir         => sub { shift->app->pref('addons_dir') };
has action_hook => sub { Markets::Addons::ActionHook->new };
has filter_hook => sub { Markets::Addons::FilterHook->new };
has [qw/app installed uploaded remove_hooks/];

sub addon {
    my $self = shift;
    return $self->{installed} unless @_;

    my $namespace = ADDON_NAME_SPACE;
    my $name = $_[0] =~ /${namespace}::(.*)/ ? decamelize $1 : decamelize $_[0];

    @_ > 1 ? $self->{installed}->{$name} = $_[1] : $self->{installed}->{$name};
}

sub init {
    my ( $self, $installed_addons ) = ( shift, shift // {} );

    $self->uploaded( $self->_fetch_uploded_addons );
    $self->remove_hooks( [] );

    foreach my $addon_class_name ( keys %{$installed_addons} ) {

        # Register addon
        my $addon_pref = $installed_addons->{$addon_class_name};
        my $addon = $self->load_addon( $addon_class_name, $addon_pref );
        $self->addon( $addon_class_name => $addon );

        # Subscribe hooks
        $self->to_enable($addon) if $addon->is_enabled;
    }

    # Remove hooks
    $self->_remove_hooks;
}

sub new {
    my $self = shift;
    $self = $self->SUPER::new( app => shift );
    Scalar::Util::weaken $self->{app};
    $self;
}

sub load_addon {
    my ( $self, $name, $addon_pref ) = @_;

    my $full_module_name = _full_module_name($name);
    $self->_add_inc_path($full_module_name) unless $full_module_name->can('new');
    return $full_module_name->new(
        app => $self->app,
        %{$addon_pref}
      )->setup
      if _load_class($full_module_name);

    die qq{Addon "$name" missing, maybe you need to upload it?\n};
}

sub subscribe_hooks {
    my ( $self, $addon ) = @_;

    my $hooks = $addon->hooks;
    foreach my $hook ( @{$hooks} ) {
        my $hook_type = $hook->{type};
        $self->$hook_type->on($hook);
    }
    $self->app->renderer->cache( Mojo::Cache->new );
}

sub to_enable {
    my ( $self, $addon ) = @_;

    # Add hooks into the App.
    $self->subscribe_hooks($addon);

    # Add routes in to the App.
    $self->_add_routes($addon);

    $addon->is_enabled(1);
}

sub to_disable {
    my ( $self, $addon ) = @_;

    # Remove hooks for App.
    $self->unsubscribe_hooks($addon);

    # Remove routes for App.
    $self->_remove_routes($addon);

    $addon->is_enabled(0);
}

sub unsubscribe_hooks {
    my ( $self, $addon ) = @_;
    my $hooks = $addon->hooks;
    foreach my $hook ( @{$hooks} ) {
        my $hook_type = $hook->{type};
        $self->$hook_type->unsubscribe( $hook->{name} => $hook );
    }
    $self->app->renderer->cache( Mojo::Cache->new );
}

sub _add_inc_path {
    my ( $self, $addon_class_name ) = @_;

    my $addons_dir = $self->dir;
    my $namespace  = ADDON_NAME_SPACE;
    my $dir        = ( $addon_class_name =~ /${namespace}::(.*)/ and $1 );

    # testスクリプト用にabs_pathを渡す必要がある。
    my $path = Mojo::File::path( $self->app->home, $addons_dir, $dir, 'lib' )->to_abs->to_string;
    push @INC, $path;
}

sub _add_routes {
    my ( $self, $addon ) = @_;
    my $r = $addon->routes;
    $self->app->routes->add_child($r) if @{ $r->children };
}

sub _fetch_uploded_addons {
    my $self       = shift;
    my $addons_dir = $self->dir;
    my $rel_dir    = Mojo::File::path( $self->app->home, $addons_dir );
    my @all_dir    = Markets::Util::directories($rel_dir);
    my @addons     = map { decamelize $_ } @all_dir;
    return Mojo::Collection->new(@addons);
}

sub _full_module_name {
    my $name      = shift;
    my $suffix    = $name =~ /^[a-z]/ ? camelize $name : $name;
    my $namespace = ADDON_NAME_SPACE;
    my $class     = $suffix =~ /${namespace}::/ ? $suffix : $namespace . '::' . $suffix;
}

sub _load_class {
    my $class = shift;
    return $class->isa(ADDON_NAME_SPACE)
      unless my $e = load_class $class;
    ref $e ? die $e : return;
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
    my ( $self, $addon ) = @_;
    my $addon_class_name = ref $addon;
    my $routes           = $self->app->routes->find($addon_class_name);

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
This module is an addon manager of Markets.

=head1 EVENTS

L<Markets::Addons> inherits all events from L<Mojo::EventEmitter> & L<Markets::EventEmitter>.

=head1 ATTRIBUTES

=head2 C<app>

    my $app = $addons->app;

Return the application object.

=head2 C<action_hook>

Markets::Addons::ActionHook object.

=head2 C<filter_hook>

Markets::Addons::FilterHook object.

=head2 C<installed>

    my $installed_addons = $addons->installed;

Return Hash ref.

=head2 C<uploaded>

    my $uploaded_addons = $addons->uploaded;

Return L<Mojo::Collection> object.
The list of all uploaded addons.

=head1 METHODS

L<Markets::Addons> inherits all methods from L<Mojolicious::EventEmitter> and implements
the following new ones.

=head2 C<addon>

    # Get all addon object
    my $installed_addons = $addons->addon; # Return Hash ref

    # Get addon Object
    my $addon = $addons->addon('my_addon');
    my $addon = $addons->addon('MyAddon');
    my $addon = $addons->addon('Markets::Addon::MyAddon');

    # Setter
    $addons->addon( 'my_addon' => Markets::Addon::MyAddon->new );

=head2 C<emit>

    # Emit action hook
    $addons->action_hook->emit('foo');
    $addons->action_hook->emit(foo => 123);

    # Emit filter hook
    $addons->filter_hook->emit('foo');
    $addons->filter_hook->emit(foo => 123);

Emit event as action/filter hook.
This method is Markets::Addons::ActionHook::emit or Markets::Addons::FilterHook::emit.

=head2 C<init>

    $addons->init(\%addon_settings);

=head2 C<load_addon>

    my $addon = $addons->load_addon( 'my_addon', $addon_pref );
    my $addon = $addons->load_addon( 'MyAddon', $addon_pref );
    my $addon = $addons->load_addon( 'Markets::Addon::MyAddon', $addon_pref );

Load an addon from the configured.
Return L<Markets::Addon> object.

=head2 C<subscribe_hooks>

    $addons->subscribe_hooks($addon);

Subscribe to C<Markets::Addons::ActionHook> or C<Markets::Addons::FilterHook> event.

=head2 C<to_enable>

    $addons->to_enable($addon_object);

Change addon status to enable.

=head2 C<to_disable>

    $addons->to_disable($addon_object);

Change addon status to disable.

=head2 C<unsubscribe_hooks>

    $addons->unsubscribe_hooks($addon);

Unsubscribe to C<Markets::Addons::ActionHook> or C<Markets::Addons::FilterHook> event.

=head1 SEE ALSO

L<Markets::EventEmitter> L<Mojolicious::Plugins> L<Mojo::EventEmitter>

=cut
