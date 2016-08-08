package Markets::Plugin::Addon;
use Mojo::Base 'Mojolicious::Plugin';
use Class::Inspector;

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

1;
