package Markets::Addon;
use Mojo::Base 'Mojolicious::Plugin';
use Carp 'croak';
use Class::Inspector;
use File::Spec;
use Mojolicious::Renderer;
use Mojo::Util qw/slurp/;
use constant {
    FORMAT  => 'html',
    HANDLER => 'ep',
};

has [qw /app hooks/];

# Make addon home path
sub addon_home { Mojo::Home->new->detect(shift) }

sub init {
    my ( $self, $app, $hooks ) = @_;
    $self->{app}   = $app;
    $self->{hooks} = $hooks;
    my $namespace = ref $self;
    my $functions = Class::Inspector->functions($namespace);

    foreach my $function ( @{$functions} ) {
        my $module_function = $namespace . '::' . $function;
        if ( $function =~ /^action_.+/ ) {
            $app->add_action(
                $function => \&{$module_function},
                { priority => $hooks->{$function} }
            );
        }
        elsif ( $function =~ /^filter_.+/ ) {
            $app->add_filter(
                $function => \&{$module_function},
                { priority => $hooks->{$function} }
            );
        }
    }
    $self->register( $self, $app, $hooks );
}

sub register { croak 'Method "register" not implemented by subclass' }

sub add_filter {
    my ( $self, $name, $cb, $conf ) = ( shift, shift, shift, shift // {} );
    my $hooks = $self->hooks;
    my $priority =
      $hooks->{$name} ? $hooks->{$name} : $conf->{default_priority};
    my ( $class, $function ) = ( caller 1 )[3] =~ /(.*)::(.*)/;
    $self->app->add_filter(
        $name => $cb,
        {
            class    => $class,
            priority => $priority
        }
    );
}

sub install   { }
sub uninstall { }
sub update    { }
sub enable    { }
sub disable   { }

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
    my ($self, $app, $conf) = @_;

    # Your addon code here!
}

=head1 DESCRIPTION

L<Markets::Addon> is L<Mojolicious::Plugin> base plugin system.

=head1 ATRIBUTES

=head2 app

    my $app = $addon->app;

Return the application object.

=head2 hooks

    my $hooks = $addon->hooks;
    # return { 'hook_name' => priority, ... }

=head1 METHODS

=head2 addon_home

  # /path/to/Markets/addon/YourAddon
  &addon_home(Markets::Addon::YourAddon)

Get home path for YourAddon.

=head2 add_filter

    sub register {
        my my ( $self, $app, $conf ) = @_;
        $self->add_filter(
            'filter_hook_name' => \&foo,
            { default_priority => 500 }    # option
        );
    }

    sub foo { ... }

Extend L<Markets> with hooks.

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
