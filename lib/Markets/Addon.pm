package Markets::Addon;
use Mojo::Base 'Mojolicious::Plugin';
use Class::Inspector;
use File::Spec;
use Mojolicious::Renderer;
use Mojo::Util qw/slurp/;
use constant {
    FORMAT => 'html',
    HANDLER => 'ep',
};

sub register {
    my ( $self, $app, $conf ) = @_;
    my $namespace = ref $self;
    my $functions = Class::Inspector->functions($namespace);

    foreach my $function ( @{$functions} ) {
        my $module_function = $namespace . '::' . $function;
        if ( $function =~ /^action_.+/ ) {
            $app->add_action(
                $function => \&{$module_function},
                { priority => $conf->{$function} }
            );
        }
        elsif ( $function =~ /^filter_.+/ ) {
            $app->add_filter(
                $function => \&{$module_function},
                { priority => $conf->{$function} }
            );
        }
    }
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

# Make addon home path
sub addon_home { Mojo::Home->new->detect(shift) }

=encoding utf8

=head1 NAME

Markets::Addon - Markets External plugin system

=head1 SYNOPSIS

  # YourAddon
  package Markets::Addon::YourAddon;
  use Mojo::Base 'Markets::Addon';

=head1 DESCRIPTION



=head1 METHODS

=head2 addon_home

  # /path/to/Markets/addon/YourAddon
  &addon_home(Markets::Addon::YourAddon)

Get home path for YourAddon.

=head2 get_template

    my $content = $class->get_template('dir/template_name');

Get content for addon template file or DATA section.

format C<html> and handler C<ep> onry. ex) template_name.html.ep

=head1 SEE ALSO

=cut

1;
