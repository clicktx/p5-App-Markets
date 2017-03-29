package Markets::Addon;
use Mojo::Base 'Mojolicious::Plugin';

use B;
use Carp 'croak';
use Mojo::Util qw/camelize decamelize/;
use Mojo::Loader qw/load_class/;
use constant {
    FORMAT  => 'html',
    HANDLER => 'ep',
};

has class_name => sub { ref shift };
has name => sub {
    my $package = __PACKAGE__;
    shift->class_name =~ /${package}::(.*)/ and decamelize $1;
};
has [qw/app config hooks is_enabled routes/];

# Make addon home path
sub addon_home { Mojo::Home->new->detect(shift) }

sub new {
    my $self = shift;
    $self = $self->SUPER::new(@_);
    Scalar::Util::weaken $self->{app};
    return $self;
}

sub register { croak 'Method "register" not implemented by subclass' }

sub setup {
    my $self = shift;

    # Routes
    my $class_name = $self->class_name;
    my $r          = Mojolicious::Routes->new;
    $r = $r->to( namespace => __PACKAGE__ )->name($class_name);
    $self->routes($r);

    # Load lexicon file.
    my $addon_home = addon_home($class_name);
    my $addon_name = $self->name;
    my $locale_dir = Mojo::File::path( $addon_home, 'locale' );
    $self->app->lexicon(
        {
            search_dirs => [$locale_dir],
            data        => [ "*::$addon_name" => '*.po' ],    # set text domain
        }
    ) if -d $locale_dir;

    # Load schema
    # TODO: $self->is_installed を作って真の場合のみ実行させる？
    my $result_class = $class_name . "::Schema::Result";
    $self->app->schema->storage->schema->load_namespaces( result_namespace => "+$result_class" );

    # Call to register method for YourAddon.
    $self->register( $self->app );
    return $self;
}

sub add_action_hook { shift->_add_hook( 'action_hook', @_ ) }
sub add_filter_hook { shift->_add_hook( 'filter_hook', @_ ) }
sub rm_action_hook { shift->_remove_hook( 'action_hook', @_ ) }
sub rm_filter_hook { shift->_remove_hook( 'filter_hook', @_ ) }

sub _add_hook {
    my ( $self, $type, $name, $cb, $arg ) = ( shift, shift, shift, shift, shift // {} );

    my $hook_prioritie   = $self->{config}->{hook_priorities}->{$name};
    my $default_priority = $arg->{default_priority} || $self->app->addons->DEFAULT_PRIORITY;
    my $priority         = $hook_prioritie ? $hook_prioritie : $default_priority;
    my $hooks            = $self->{hooks};
    my $cb_fn_name = B::svref_2object($cb)->GV->NAME;    # TODO: 必要か再考

    push @{$hooks},
      {
        name             => $name,
        type             => $type,
        cb               => $cb,
        cb_fn_name       => $cb_fn_name,
        priority         => $priority,
        default_priority => $default_priority,
      };
}

sub _remove_hook {
    my ( $self, $type, $hook, $cb_fn_name ) = @_;
    my $remove_hooks = $self->app->addons->{remove_hooks};
    push @{$remove_hooks},
      {
        type       => $type,
        hook       => $hook,
        cb_fn_name => $cb_fn_name,
      };
}

sub install {
    my $self = shift;

    # Create Tables
    my $class_name   = ref $self;
    my $schema_class = $class_name . "::Schema";

    if ( my $e = load_class $schema_class ) {
        die "Exception: $e" if ref $e;
    }
    else {
        my $schema       = $self->app->schema;
        my $connect_info = $schema->storage->connect_info;
        my $self_schema  = $schema_class->connect( $connect_info->[0] );
        $self_schema->deploy;
    }
    return $self;
}

sub uninstall { }
sub update    { }

sub enable {

    # check: 現在enableなら処理をしない
}

sub disable {

    # check: 現在disableなら処理をしない
}

sub get_template {
    my ( $class, $template ) = @_;
    return 'Not argument, template path' unless $template;

    # Addon templates directory
    my $home = addon_home($class);
    my $templates_dir = Mojo::File::path( $home, 'templates' );

    my $renderer = Mojolicious::Renderer->new;
    push @{ $renderer->classes }, $class;
    push @{ $renderer->paths },   $templates_dir;

    my $options = {
        template => $template,
        format   => FORMAT,
        handler  => HANDLER
    };

    # Try template
    if ( defined( my $path = $renderer->template_path($options) ) ) {
        Mojo::File::path($path)->slurp;
    }

    # Try DATA section
    elsif ( defined( my $d = $renderer->get_data_template($options) ) ) { $d }

    # No template
    else { "Not found template." }

}

=encoding utf8

=head1 NAME

Markets::Addon - Markets External plugin system

=head1 SYNOPSIS

  # YourAddon
  package Markets::Addon::YourAddon;
  use Mojo::Base 'Markets::Addon';

  sub register {
    my ($self, $app, $arg) = @_;

    # Your addon code here!
}

=head1 DESCRIPTION

L<Markets::Addon> is L<Mojolicious::Plugin> base plugin system.

=head1 ATRIBUTES

=head2 C<app>

    my $app = $addon->app;

Return the application object.

=head2 C<class_name>

    my $class_name = $addon->class_name;

Return the class name of addon.

=head2 C<name>

    my $addon_name = $addon->name;

Return the addon name.

=head2 C<is_enabled>

Return boolean.

=head2 C<routes>

    my $r = $addon->routes;

    # Markets::Addon::AddonName::Controller::action()
    # template AddonName/templates/addon_name/controller/action.html.ep
    $r->get('/')->to('addon_name-controller#action');

Return L<Mojolicious::Routes> object.

=head1 METHODS

L<Markets::Addon> inherits all methods from L<Mojolicious::Plugin> and
implements the following new ones.

=head2 C<addon_home>

  # /path/to/Markets/addon/YourAddon
  &addon_home(Markets::Addon::YourAddon)

Get home path for YourAddon.

=head2 C<add_action_hook>

    sub register {
        my my ( $self, $app, $arg ) = @_;
        $self->add_action_hook(
            'action_hook_name' => \&fizz,
            { default_priority => 500 }    # option
        );
    }

    sub fizz { ... }

Extend L<Markets> with action hook event.

=head2 C<add_filter_hook>

    sub register {
        my my ( $self, $app, $arg ) = @_;
        $self->add_filter_hook(
            'filter_hook_name' => \&buzz,
            { default_priority => 500 }    # option
        );
    }

    sub buzz { ... }

Extend L<Markets> with filter hook event.

=head2 C<rm_action_hook>

    $addon->rm_action_hook( 'action_hook_name', 'subroutine_name');

Remove L<Markets> action hook event.

=head2 C<rm_filter_hook>

    $addon->rm_filter_hook( 'filter_hook_name', 'subroutine_name');

Remove L<Markets> filter hook event.

=head2 C<get_template>

    my $content = $class->get_template('dir/template_name');

Get content for addon template file or DATA section.

format C<html> and handler C<ep> onry. ex) template_name.html.ep

=head2 C<setup>

This method will be called by L<Markets::Addon> at startup time.

=head2 C<register>

This method will be called after L<Markets::Addon>::setup() at startup time.
Meant to be overloaded in a subclass.

=head1 SEE ALSO

L<Markets::Addons> L<Mojolicious::Plugin>

=cut

1;
