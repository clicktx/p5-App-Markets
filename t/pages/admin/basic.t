use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;
my $ua  = $t->ua;

# use DDP;
# p $app->routes->find('RN_admin')->children;
# subtest 'pages' => sub {
#     my @paths;
#     foreach my $r ( @{ $app->routes->find('RN_admin')->children } ) {
#         push @paths, $r->render if $r->is_endpoint;
#     }
#     p @paths;
# };

sub _make_path {
    my @paths;
    my $routes = shift;
    foreach my $r ( @{$routes} ) {
        if ( $r->is_endpoint ) { push @paths, $r->render }
        else                   { _make_path( $r->children ) }
    }
    return \@paths;
}
subtest 'requred authrization pages' => sub {
    my $paths = _make_path( $app->routes->find('RN_admin_bridge')->children );
    $t->get_ok($_)->status_is( 302, 'right redirect' ) for @{$paths};
};

# $ua->max_redirects(10);

done_testing();
