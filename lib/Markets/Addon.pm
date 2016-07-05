package Markets::Addon;
use Mojo::Base 'Mojolicious::Plugin';
use Class::Inspector;

sub register {
    my ( $self, $app, $conf ) = @_;
    my $namespace = ref $self;
    my $functions = Class::Inspector->functions($namespace);

    foreach my $function ( @{$functions} ) {
        if ( $function =~ /^before_.+|^after_.+/ ) {
            $app->add_filter(
                $function => \&{"$namespace::$function"},
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
