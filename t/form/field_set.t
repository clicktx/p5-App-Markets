use Mojo::Base -strict;
use Test::More;
use Test::Deep;
use Test::Mojo;
use t::Util;
use Mojo::DOM;

use_ok 'Markets::Form::FieldSet';

my $t = Test::Mojo->new('App');
my $c = $t->app->build_controller;

use_ok 'Markets::Form::FieldSet::Test';
my $fs = Markets::Form::FieldSet::Test->new( controller => $c );

subtest 'attributes' => sub {
    ok( $fs->can($_), "right $_" ) for qw(controller schema);
};

subtest 'c' => sub {
    ok $fs->can('c');
    isa_ok $fs->c( 1, 2, 3 ), 'Mojo::Collection';
};

subtest 'checks' => sub {
    is $fs->checks('hoge'), undef, 'right not exist field_key';
    cmp_deeply $fs->checks('email'), [ [ size => 2, 5 ], [ like => ignore() ] ], 'right get validations';
    cmp_deeply $fs->checks,
      {
        email => [ [ size => 2, 5 ], [ like => ignore() ] ],
        name => [],
        address        => [],
        favorite_color => [],
        luky_number    => [],
        'item.[].id'   => [],
        'item.[].name' => [],
      },
      'right all field_key validations';
};

subtest 'export_field' => sub {
    is_deeply __PACKAGE__->schema, {}, 'right not exported';

    $fs->export_field('item.[].id');
    is_deeply __PACKAGE__->schema('item.[].id'),
      {
        type        => 'text',
        label       => 'Item ',
        required    => 1,
        filters     => [],
        validations => [],
      },
      'right export field';

    # Export all fields
    $fs->export_field();
    is_deeply \@{ __PACKAGE__->field_keys },
      [qw(item.[].id email name address favorite_color luky_number item.[].name)], 'right exported all';
};

subtest 'field' => sub {
    my $f = $fs->field('email');
    isa_ok $f, 'Markets::Form::Field';
};

subtest 'field_keys' => sub {
    my @field_keys = $fs->field_keys;
    is_deeply \@field_keys, [qw/email name address favorite_color luky_number item.[].id item.[].name/],
      'right field_keys';
    my $field_keys = $fs->field_keys;
    is ref $field_keys, 'ARRAY', 'right scalar';
};

subtest 'filters' => sub {
    is $fs->filters('hoge'), undef, 'right not exist field_key';
    is ref $fs->filters('name'), 'ARRAY', 'right filters';
    cmp_deeply $fs->filters,
      {
        email          => [qw/trim/],
        name           => [],
        address        => [],
        favorite_color => [],
        luky_number    => [],
        'item.[].id'   => [],
        'item.[].name' => [qw/trim/],
      },
      'right all filters';
};

subtest 'parameters' => sub {

    # Create new request
    my $c = $t->app->build_controller;
    my $fs = Markets::Form::FieldSet::Test->new( controller => $c );
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

    eval { my $name = $fs->param('name') };
    ok $@, 'right before validate';

    $fs->validate;
    is $fs->param('email'), 'a@b.c', 'right param';
    is_deeply $fs->param('favorite_color[]'), ['red'], 'right every param';
    is_deeply $fs->scope_param('item'),
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
    is $fs->param('iligal_param'), undef, 'right iligal param';
};

subtest 'render tags' => sub {
    ok !$fs->render_error('email');
    is ref $fs->render_help('email'),  'Mojo::ByteStream', 'right render_help method';
    is ref $fs->render_label('email'), 'Mojo::ByteStream', 'right render_label method';
    is ref $fs->render('email'),       'Mojo::ByteStream', 'right render method';
};

subtest 'schema' => sub {
    my $schema = $fs->schema;
    is ref $schema, 'HASH';
    my $field_schema = $fs->schema('email');
    is ref $field_schema, 'HASH';
};

subtest 'validate' => sub {

    # Create new request
    my $c = $t->app->build_controller;
    my $fs = Markets::Form::FieldSet::Test->new( controller => $c );
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
    my $result = $fs->validate;
    ok !$result, 'right failed validation';

    my $v = $fs->controller->validation;
    my ( $check, $res, @args ) = @{ $v->error('email') };
    is $check, 'like', 'right validation error';
    is_deeply $v->error('name'),      ['required'], 'right required';
    is_deeply $v->error('item.1.id'), ['required'], 'right required';

    # Create new request
    $c = $t->app->build_controller;
    $fs = Markets::Form::FieldSet::Test->new( controller => $c );
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
    $result = $fs->validate;
    ok $result, 'right validation';
};

subtest 'validate with filter' => sub {

    # Create new request
    my $c = $t->app->build_controller;
    my $fs = Markets::Form::FieldSet::Test->new( controller => $c );
    $c->req->params->pairs(
        [
            'email'       => '   a@b.c   ',
            'item.0.name' => ' aaa ',
            'item.1.name' => ' bbb ',
            'item.2.name' => ' ccc ',
        ]
    );
    $fs->validate;
    my $v = $c->validation;
    is $v->param('email'),       'a@b.c';
    is $v->param('item.0.name'), 'aaa';
    is $v->param('item.1.name'), 'bbb';
    is $v->param('item.2.name'), 'ccc';

    # field value after render
    my $dom = Mojo::DOM->new( $fs->render('email') );
    is_deeply $dom->at('*')->attr->{value}, 'a@b.c', 'right filtering value';

    $dom = Mojo::DOM->new( $fs->render('item.0.name') );
    is_deeply $dom->at('*')->attr->{value}, 'aaa', 'right filtering value';
};

# This test should be done at the end!
subtest 'append/remove' => sub {
    $fs->append( aaa => ( type => 'text' ) );
    my @field_keys = $fs->field_keys;
    is_deeply \@field_keys, [qw/email name address favorite_color luky_number item.[].id item.[].name aaa/],
      'right field_keys';

    $fs->remove('name');
    @field_keys = $fs->field_keys;
    is_deeply \@field_keys, [qw/email address favorite_color luky_number item.[].id item.[].name aaa/],
      'right field_keys';
};

done_testing();
