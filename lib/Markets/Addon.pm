package Markets::Addon;
use Mojo::Base 'Mojolicious::Plugin';
use Carp 'croak';
use File::Spec;
use Mojolicious::Renderer;
use Mojo::Util qw/slurp/;
use constant {
    FORMAT  => 'html',
    HANDLER => 'ep',
};

has [qw /app hook_priorities/];

# Make addon home path
sub addon_home { Mojo::Home->new->detect(shift) }
sub register   { croak 'Method "register" not implemented by subclass' }

sub init {
    my ( $self, $app, $hook_priorities ) = @_;
    $self->{app}             = $app;
    $self->{hook_priorities} = $hook_priorities;

    my $namespace = ref $self;
    $app->defaults->{addons}->{$namespace} = { hooks => [] };
    $self->register( $app, $hook_priorities );

    # enableのアドオンのみフック登録
    say $self->is_enabled($namespace);

}

sub is_enabled {
    my ( $self, $namespace )  = @_;
    my ( undef, $addon_name ) = $namespace =~ /(.*)::(.*)/;    # TODO: 簡易版
    my $addons = $self->app->config->{addons};
    $addons->{$addon_name}->{is_enabled};
}

sub add_action {
    my $caller = ( caller 1 )[3];
    shift->_add_hook( $caller, 'action', @_ );
}

sub add_filter {
    my $caller = ( caller 1 )[3];
    shift->_add_hook( $caller, 'filter', @_ );
}

sub _add_hook {
    my ( $self, $caller, $hook_type, $hook_name, $cb, $arg ) =
      ( shift, shift, shift, shift, shift, shift // {} );
    my ( $namespace, $function ) = $caller =~ /(.*)::(.*)/;
    my $hook_priorities = $self->hook_priorities->{$hook_name};
    my $default_priority =
      $arg->{default_priority} || $self->app->addons->default_priority;
    my $priority = $hook_priorities ? $hook_priorities : $default_priority;

    my $hooks = $self->app->stash->{addons}->{$namespace}->{hooks};
    push @{$hooks},
      {
        name             => $hook_name,
        type             => $hook_type,
        cb               => $cb,
        priority         => $priority,
        default_priority => $default_priority,
      };
    use Data::Dumper;
    say Dumper $self->app->defaults;

    $self->app->$hook_type->on_hook(
        $hook_name => $cb,
        {
            namespace => $namespace,
            priority  => $priority
        }
    );
}

sub install   { }
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
    my $templates_dir = File::Spec->catdir( $home, 'templates' );

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
        slurp $path;
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

  sub init {
    my ($self, $app, $arg) = @_;

    # Your addon code here!
}

=head1 DESCRIPTION

L<Markets::Addon> is L<Mojolicious::Plugin> base plugin system.

=head1 ATRIBUTES

=head2 app

    my $app = $addon->app;

Return the application object.

=head2 hook_priorities

    my $hook_priorities = $addon->hook_priorities;
    # return { 'hook_name' => priority, ... }

=head1 METHODS

=head2 addon_home

  # /path/to/Markets/addon/YourAddon
  &addon_home(Markets::Addon::YourAddon)

Get home path for YourAddon.

=head2 add_filter

    sub register {
        my my ( $self, $app, $arg ) = @_;
        $self->add_filter(
            'filter_hook_name' => \&foo,
            { default_priority => 500 }    # option
        );
    }

    sub foo { ... }

Extend L<Markets> with hook.

=head2 get_template

    my $content = $class->get_template('dir/template_name');

Get content for addon template file or DATA section.

format C<html> and handler C<ep> onry. ex) template_name.html.ep

=head2 init

This method will be called by L<Markets::Addon> at startup time.

=head2 register

This method will be called after L<Markets::Addon>::init() at startup time.
Meant to be overloaded in a subclass.

=head1 SEE ALSO

L<Mojolicious::Plugin>

=cut

1;
