use Mojo::Base -strict;
use Test::More;
use Test::Mojo;
use t::Util;

my $t = Test::Mojo->new('App');

use_ok 'Yetie::Form::Base';
my $f = Yetie::Form::Base->new('test');
isa_ok $f->controller, 'Mojolicious::Controller';
isa_ok $f->fieldset,   'Yetie::Form::FieldSet::Test';
ok !$f->is_validated, 'right is_validated';
ok $f->name_space, 'right name_space';

subtest 'has controller' => sub {
    my $c = $t->app->build_controller;

    my $f = Yetie::Form::Base->new( 'test', controller => $c );
    isa_ok $f->validation, 'Mojolicious::Validator::Validation';

    eval { $f->params };
    ok $@, 'right not call validate';
};

subtest 'has_data' => sub {
    my $c = $t->app->build_controller;
    my $f = Yetie::Form::Base->new( 'test', controller => $c );
    is $f->has_data, '', 'right has not data';

    # Create new request
    $c = $t->app->build_controller;
    $f = Yetie::Form::Base->new( 'test', controller => $c );
    $c->req->params->pairs( [ email => 'a@b.c', ] );
    is $f->has_data, 1, 'right has data';
};

subtest 'validate' => sub {
    my $c = $t->app->build_controller;
    my $f = Yetie::Form::Base->new( 'test', controller => $c );
    $c->req->params->pairs(
        [
            email              => 'a@b33',
            name               => '',
            address            => 'ny',
            'favorite_color[]' => 'red',
            'luky_number[]'    => 2,
            'luky_number[]'    => 3,
            'item.0.id'        => 11,
            'item.1.id'        => '',
            'item.2.id'        => 33,
            'item.0.name'      => '',
            'item.1.name'      => '',
            'item.2.name'      => '',
        ]
    );
    my $result = $f->validate;
    ok !$result, 'right failed validation';

    my $v = $f->controller->validation;
    my ( $check, $res, @args ) = @{ $v->error('email') };
    is $check, 'like', 'right validation error';
    is_deeply $v->error('name'),      ['required'], 'right required';
    is_deeply $v->error('item.1.id'), ['required'], 'right required';

    # Create new request
    $c = $t->app->build_controller;
    $f = Yetie::Form::Base->new( 'test', controller => $c );
    $c->req->params->pairs(
        [
            email              => 'a@b.c',
            name               => 'frank',
            address            => 'ny',
            'favorite_color[]' => 'red',
            'luky_number[]'    => 2,
            'luky_number[]'    => 3,
            'item.0.id'        => 11,
            'item.1.id'        => 22,
            'item.2.id'        => 33,
            'item.0.name'      => '',
            'item.1.name'      => '',
            'item.2.name'      => '',
        ]
    );
    $result = $f->validate;
    ok $result, 'right validation';
};

done_testing();
