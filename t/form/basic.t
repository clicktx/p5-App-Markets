use Mojo::Base -strict;
use Test::More;
use Test::Mojo;
use t::Util;

my $t = Test::Mojo->new('App');

subtest 'helpers' => sub {
    my $c = $t->app->build_controller;

    can_ok $c->helpers, 'form_error';
    can_ok $c->helpers, 'form_help';
    can_ok $c->helpers, 'form_label';
    can_ok $c->helpers, 'form_set';
    can_ok $c->helpers, 'form_widget';
};

subtest 'form_set' => sub {
    my $c = $t->app->build_controller;
    $c->stash( controller => 'test', action => 'index' );

    my $fs = $c->form_set;
    isa_ok $fs, 'Markets::Form::FieldSet', 'right not arguments';
};

done_testing();
