package Yetie::Addon::NoInstallAddon;
use Mojo::Base 'Yetie::Addon::Base';

use Data::Dumper;

my $class = __PACKAGE__;
my $home  = $class->addon_home;    # get this addon home abs path.

sub register {
    my ( $self, $app, $conf ) = @_;
    say "register by NoInstallAddon";
}

1;
