package Yetie::Addon::DisableAddon;
use Mojo::Base 'Yetie::Addon::Base';

use Data::Dumper;

my $class = __PACKAGE__;
my $home  = $class->addon_home;    # get this addon home abs path.

sub register {
    my ( $self, $app, $conf ) = @_;
    say "Disabled addon register by DisableAddon";
}

sub install   { }
sub uninstall { }
sub update    { }
sub enable { }
sub disable { }

1;
