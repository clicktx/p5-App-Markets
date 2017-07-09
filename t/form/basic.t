use Mojo::Base -strict;
use Test::More;
use Test::Mojo;
use t::Util;

my $t = Test::Mojo->new('App');
my $c = $t->app->build_controller;

can_ok $c->helpers, 'form_error';
can_ok $c->helpers, 'form_help';
can_ok $c->helpers, 'form_label';
can_ok $c->helpers, 'form_set';
can_ok $c->helpers, 'form_widget';

done_testing();
