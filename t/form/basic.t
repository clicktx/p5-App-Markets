use Mojo::Base -strict;
use Test::More;
use Test::Mojo;
use t::Util;

my $t = Test::Mojo->new('App');
my $c = $t->app->build_controller;

is $c->form_error_message(''), undef, 'right not found message';
ok $c->form_error_message('required'), 'right message';

done_testing();
