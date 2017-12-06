use Mojo::Base -strict;
use Test::More;
use Test::Mojo;
use t::Util;
use Mojo::Collection qw(c);

my $t = Test::Mojo->new('App');
use_ok 'Yetie::Form::Base';

subtest 'basic' => sub {
    my $f = Yetie::Form::Base->new('test');
    isa_ok $f->controller, 'Mojolicious::Controller';
    isa_ok $f->field('email'), 'Yetie::Form::Field';
    isa_ok $f->fieldset, 'Yetie::Form::FieldSet::Test';
    ok !$f->is_validated, 'right is_validated';
    ok $f->name_space,      'right name_space';
    isa_ok $f->tag_helpers, 'Yetie::Form::TagHelpers';
};

subtest 'with controller' => sub {
    my $c = $t->app->build_controller;
    my $f = Yetie::Form::Base->new( 'test', controller => $c );
    isa_ok $f->validation, 'Mojolicious::Validator::Validation';
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

subtest 'fill_in' => sub {
    my $c = $t->app->build_controller;
    my $f = Yetie::Form::Base->new( 'test', controller => $c );
    my $e = Yetie::Domain::Factory->new('test')->create_entity();

    # choice singular
    $f->field('favorite_color')->type('choice');
    $f->field('favorite_color')->multiple(0);
    $f->field('favorite_color')->expanded(0);
    $f->field('favorite_color')->choices( [qw(red green blue)] );
    $e->favorite_color('green');
    my $result = $f->fill_in($e);
    isa_ok $result, 'Yetie::Form::Base', 'right return value';
    is_deeply $f->field('favorite_color')->choices, [ 'red', [ green => 'green', choiced => 1 ], 'blue' ],
      'right choice singular';

    $f->field('favorite_color')->choices( [ 'red', [ Green => 'green' ], 'blue' ] );
    $f->fill_in($e);
    is_deeply $f->field('favorite_color')->choices, [ 'red', [ Green => 'green', choiced => 1 ], 'blue' ],
      'right choice singular';

    $f->field('favorite_color')
      ->choices( [ c( Warm => [ [ Red => 'red' ], [ Yellow => 'yellow' ] ] ), c( Cool => [ 'green', 'blue' ] ) ] );
    $f->fill_in($e);
    is_deeply $f->field('favorite_color')->choices,
      [
        c( Warm => [ [ Red => 'red' ], [ Yellow => 'yellow' ] ] ),
        c( Cool => [ [ green => 'green', choiced => 1 ], 'blue' ] )
      ],
      'right choice singular';

    $f->field('favorite_color')
      ->choices( [ c( Warm => [ [ Red => 'red' ], [ Yellow => 'yellow' ] ] ), c( Cool => [ 'green', 'blue' ] ) ] );
    $e->favorite_color('yellow');
    $f->fill_in($e);
    is_deeply $f->field('favorite_color')->choices,
      [ c( Warm => [ [ Red => 'red' ], [ Yellow => 'yellow', choiced => 1 ] ] ), c( Cool => [ 'green', 'blue' ] ) ],
      'right choice singular';

    # choice multiple
    $f->field('favorite_color')->multiple(1);
    $f->field('favorite_color')->expanded(0);
    $f->field('favorite_color')->choices( [qw(red green blue)] );
    $e->favorite_color( [ 'green', 'blue' ] );
    $f->fill_in($e);
    is_deeply $f->field('favorite_color')->choices,
      [ 'red', [ green => 'green', choiced => 1 ], [ blue => 'blue', choiced => 1 ] ], 'right choice multiple';

    $f->field('favorite_color')->choices( [ 'red', [ Green => 'green' ], 'blue' ] );
    $f->fill_in($e);
    is_deeply $f->field('favorite_color')->choices,
      [ 'red', [ Green => 'green', choiced => 1 ], [ blue => 'blue', choiced => 1 ] ], 'right choice multiple';

    $f->field('favorite_color')
      ->choices( [ c( Warm => [ [ Red => 'red' ], [ Yellow => 'yellow' ] ] ), c( Cool => [ 'green', 'blue' ] ) ] );
    $f->fill_in($e);
    is_deeply $f->field('favorite_color')->choices,
      [
        c( Warm => [ [ Red => 'red' ], [ Yellow => 'yellow' ] ] ),
        c( Cool => [ [ green => 'green', choiced => 1 ], [ blue => 'blue', choiced => 1 ] ] )
      ],
      'right choice multiple';

    $f->field('favorite_color')
      ->choices( [ c( Warm => [ [ Red => 'red' ], [ Yellow => 'yellow' ] ] ), c( Cool => [ 'green', 'blue' ] ) ] );
    $e->favorite_color( [ 'yellow', 'green' ] );
    $f->fill_in($e);
    is_deeply $f->field('favorite_color')->choices,
      [
        c( Warm => [ [ Red => 'red' ], [ Yellow => 'yellow', choiced => 1 ] ] ),
        c( Cool => [ [ green => 'green', choiced => 1 ], 'blue' ] )
      ],
      'right choice multiple';

    # select
    $f->field('luky_number')->type('select');
    $f->field('luky_number')->choices( [qw(1 2 3)] );
    $e->luky_number(2);
    $f->fill_in($e);
    is_deeply $f->field('luky_number')->choices, [ 1, [ 2 => 2, choiced => 1 ], 3 ], 'right select';

    # radio
    $f->field('luky_number')->type('radio');
    $f->field('luky_number')->choices( [qw(1 2 3)] );
    $e->luky_number(2);
    $f->fill_in($e);
    is_deeply $f->field('luky_number')->choices, [ 1, [ 2 => 2, choiced => 1 ], 3 ], 'right radio';

    # checkbox
    $f->field('luky_number')->type('checkbox');
    $f->field('luky_number')->choices( [qw(1 2 3)] );
    $e->luky_number(2);
    $f->fill_in($e);
    is_deeply $f->field('luky_number')->choices, [ 1, [ 2 => 2, choiced => 1 ], 3 ], 'right checkbox';

    # exception
    $e->luky_number( c( 2, 3 ) );
    eval { $f->fill_in($e) };
    ok $@, 'right exception';
};

subtest 'parameters' => sub {
    my $c = $t->app->build_controller;
    my $f = Yetie::Form::Base->new( 'test', controller => $c );
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
            'item.0.name'      => 'aa',
            'item.1.name'      => 'bb',
            'item.2.name'      => 'cc',
            iligal_param       => 'attack',
        ]
    );

    eval { my $name = $f->param('name') };
    ok $@, 'right before validate';

    $f->validate;
    is $f->param('email'), 'a@b.c', 'right param';
    is_deeply $f->param('favorite_color[]'), ['red'], 'right every param';
    is_deeply $f->scope_param('item'),
      [
        {
            id   => 11,
            name => 'aa',
        },
        {
            id   => 22,
            name => 'bb',
        },
        {
            id   => 33,
            name => 'cc',
        },
      ],
      'right scope param';
    is $f->param('iligal_param'), undef, 'right iligal param';

    # to_hash
    my $params = $f->params->to_hash;
    is_deeply $params->{'favorite_color[]'}, ['red'], 'right every param to_hash';
};

subtest 'render tags' => sub {
    my $c = $t->app->build_controller;
    my $f = Yetie::Form::Base->new( 'test', controller => $c );
    ok !$f->render_error('email');
    is ref $f->render_help('email'),  'Mojo::ByteStream', 'right render_help method';
    is ref $f->render_label('email'), 'Mojo::ByteStream', 'right render_label method';
    is ref $f->render('email'),       'Mojo::ByteStream', 'right render method';
};

subtest 'render tags with attrs' => sub {
    my $c   = $t->app->build_controller;
    my $f   = Yetie::Form::Base->new( 'test', controller => $c );
    my $dom = Mojo::DOM->new( $f->render('email') );
    is_deeply $dom->at('*')->attr->{value},       undef,         'right value';
    is_deeply $dom->at('*')->attr->{placeholder}, 'name@domain', 'right placeholder';

    $f = Yetie::Form::Base->new( 'test', controller => $c );
    $dom = Mojo::DOM->new( $f->render( 'email', value => 'foo', placeholder => 'bar' ) );
    is_deeply $dom->at('*')->attr->{value},       'foo', 'right value';
    is_deeply $dom->at('*')->attr->{placeholder}, 'bar', 'right placeholder';
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

subtest 'validate with filter' => sub {
    my $c = $t->app->build_controller;
    my $f = Yetie::Form::Base->new( 'test', controller => $c );
    $c->req->params->pairs(
        [
            'email'       => '   a@b.c   ',
            'item.0.name' => ' aaa ',
            'item.1.name' => ' bbb ',
            'item.2.name' => ' ccc ',
        ]
    );
    $f->validate;
    my $v = $c->validation;
    is $v->param('email'),       'a@b.c';
    is $v->param('item.0.name'), 'aaa';
    is $v->param('item.1.name'), 'bbb';
    is $v->param('item.2.name'), 'ccc';

    # field value after render
    my $dom = Mojo::DOM->new( $f->render('email') );
    is_deeply $dom->at('*')->attr->{value}, 'a@b.c', 'right filtering value';

    $dom = Mojo::DOM->new( $f->render('item.0.name') );
    is_deeply $dom->at('*')->attr->{value}, 'aaa', 'right filtering value';
};

done_testing();
