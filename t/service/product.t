use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

use_ok 'Markets::Service::Product';
my $pref = $app->service('product');

can_ok $pref, 'create_entity';

done_testing();

__END__
