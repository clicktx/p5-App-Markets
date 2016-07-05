package Markets::Addon;
use Mojo::Base 'Mojolicious::Plugin';
use Class::Inspector;

use Carp 'croak';

sub register {
    my ( $self, $app, $conf ) = @_;
    say "  added addon from Markets::Addon::register()";

    my $addon_namespace = ref $self;
    my $functions       = Class::Inspector->functions($addon_namespace);

    foreach my $function ( @{$functions} ) {
        if ( $function =~ /^before_.+|^after_.+/ ) {
            $app->add_filter(
                $function => \&{"$addon_namespace::$function"},
                { priority => $conf->{$function} }
            );
        }
    }
}

sub install   { croak 'Method "install" not implemented by subclass' }
sub uninstall { croak 'Method "install" not implemented by subclass' }
sub update    { croak 'Method "update" not implemented by subclass' }
sub enable    { croak 'Method "enable" not implemented by subclass' }
sub disable   { croak 'Method "disable" not implemented by subclass' }

1;
