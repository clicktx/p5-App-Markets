use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

sub _init {
    my $c = $app->build_controller;
    return ( $c, $c->service('shipping') );
}

ok 1;

done_testing();

__END__
