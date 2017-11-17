use Mojo::Base -strict;
use Test::More;
use Test::Mojo;
use t::Util;

my $t         = Test::Mojo->new('App');
my $stash_key = 'yetie.form';

subtest 'helpers' => sub {
    my $c = $t->app->build_controller;

    can_ok $c->helpers, 'form';
    can_ok $c->helpers, 'form_field';
    can_ok $c->helpers, 'form_error';
    can_ok $c->helpers, 'form_help';
    can_ok $c->helpers, 'form_label';
    can_ok $c->helpers, 'form_set';
    can_ok $c->helpers, 'form_widget';

    $c->form_field('test#field_name');
    is $c->stash('yetie.form.topic_field'), 'test#field_name', 'right topic_field';
    ok $c->form_widget('test#name'), 'right form widget';
};

subtest 'form' => sub {
    my $c = $t->app->build_controller;
    $c->form('test');
    ok $c->stash($stash_key)->{test}, 'right store stash';
    is $c->stash( $stash_key . '.topic' ), 'test', 'right topic form';

    $c->form('search');
    ok $c->stash($stash_key)->{search}, 'right store stash';
    is $c->stash( $stash_key . '.topic' ), 'search', 'right topic form';
};

subtest 'form_set' => sub {
    my $c = $t->app->build_controller;
    $c->stash( controller => 'test', action => 'index' );

    my $fs = $c->form_set;
    isa_ok $fs, 'Yetie::Form::FieldSet::Test::Index', 'right not arguments';
};

done_testing();
