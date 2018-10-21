package Yetie::Addon::Handler;
use Mojo::Base -base;
use Yetie::Addon::Trigger;

use Mojo::Loader 'load_class';
use Mojo::Util qw/camelize decamelize/;
use Mojo::File;
use Mojo::Collection;
use constant { NAME_SPACE => 'Yetie::Addon' };

has dir     => sub { shift->app->pref('addons_dir') };
has trigger => sub { Yetie::Addon::Trigger->new( shift->app ) };
has [qw/app installed uploaded/];

sub addon {
    my $self = shift;
    return $self->{installed} unless @_;

    my $namespace = NAME_SPACE;
    my $name = $_[0] =~ /${namespace}::(.*)/ ? decamelize $1 : decamelize $_[0];

    @_ > 1 ? $self->{installed}->{$name} = $_[1] : $self->{installed}->{$name};
}

sub emit_trigger { shift->trigger->emit(@_) }

sub init {
    my ( $self, $installed_addons ) = ( shift, shift // {} );

    $self->uploaded( $self->_fetch_uploded_addons );
    $self->trigger->remove_list( [] );

    foreach my $addon_class_name ( keys %{$installed_addons} ) {

        # Register addon
        my $addon_pref = $installed_addons->{$addon_class_name};
        my $addon = $self->load_addon( $addon_class_name, $addon_pref );
        $self->addon( $addon_class_name => $addon );

        # Subscribe triggers
        $self->to_enable($addon) if $addon->is_enabled;
    }

    # Remove triggers
    $self->trigger->remove_triggers;
}

sub new {
    my $self = shift;
    return $self->SUPER::new( app => shift );
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

sub to_enable {
    my ( $self, $addon ) = @_;

    # Add routes in to the App.
    $self->_add_routes($addon);

    $self->trigger->subscribe_triggers( $addon->triggers );
    $addon->is_enabled(1);
}

sub to_disable {
    my ( $self, $addon ) = @_;

    # Remove routes for App.
    $self->_remove_routes($addon);

    $self->trigger->unsubscribe_triggers( $addon->triggers );
    $addon->is_enabled(0);
}

sub _add_inc_path {
    my ( $self, $addon_class_name ) = @_;

    my $addons_dir = $self->dir;
    my $namespace  = NAME_SPACE;
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
    my @all_dir    = Yetie::Util::directories($rel_dir);
    my @addons     = map { decamelize $_ } @all_dir;
    return Mojo::Collection->new(@addons);
}

sub _full_module_name {
    my $name      = shift;
    my $suffix    = $name =~ /^[a-z]/ ? camelize $name : $name;
    my $namespace = NAME_SPACE;
    my $class     = $suffix =~ /${namespace}::/ ? $suffix : $namespace . '::' . $suffix;
}

sub _load_class {
    my $class = shift;
    return $class->isa( NAME_SPACE . '::Base' )
      unless my $e = load_class $class;
    ref $e ? die $e : return;
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

1;

=encoding utf8

=head1 NAME

Yetie::Addon::Handler - Addon manager for Yetie

=head1 SYNOPSIS


=head1 DESCRIPTION

L<Yetie::Addon::Handler> is L<Mojolicious::Plugins> based add-on manager for L<Yetie>.

=head1 EVENTS

L<Yetie::Addon::Handler> inherits all events from L<Mojo::Base>.

=head1 ATTRIBUTES

=head2 C<app>

    my $app = $addons->app;

Return the application object.

=head2 C<installed>

    my $installed_addons = $addons->installed;

Return Hash ref.

=head2 C<uploaded>

    my $uploaded_addons = $addons->uploaded;

Return L<Mojo::Collection> object.
The list of all uploaded add-ons.

=head1 METHODS

L<Yetie::Addon::Handler> inherits all methods from L<Mojo::Base> and implements
the following new ones.

=head2 C<addon>

    # Get all addon object
    my $installed_addons = $addons->addon; # Return Hash ref

    # Get addon Object
    my $addon = $addons->addon('my_addon');
    my $addon = $addons->addon('MyAddon');
    my $addon = $addons->addon('Yetie::Addon::MyAddon');

    # Setter
    $addons->addon( 'my_addon' => Yetie::Addon::MyAddon->new );

=head2 C<emit_trigger>

    $app->addons->emit_trigger( xxx_trigger_name => $foo, $bar, $baz );

Emit L<Yetie::Addon::Trigger> events as triggers.

=head2 C<init>

    $addons->init(\%addon_settings);

=head2 C<load_addon>

    my $addon = $addons->load_addon( 'my_addon', $addon_pref );
    my $addon = $addons->load_addon( 'MyAddon', $addon_pref );
    my $addon = $addons->load_addon( 'Yetie::Addon::MyAddon', $addon_pref );

Load an add-on from the configured.
Return L<Yetie::Addon::Base> object.

=head2 C<to_enable>

    $addons->to_enable($addon_object);

Change add-on status to enable.

=head2 C<to_disable>

    $addons->to_disable($addon_object);

Change add-on status to disable.

=head1 SEE ALSO

L<Yetie::Addon::Trigger> L<Yetie::Addon::Base>

=cut
