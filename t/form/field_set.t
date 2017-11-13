use Mojo::Base -strict;
use Test::More;
use Test::Deep;
use Test::Mojo;
use t::Util;
use Mojo::DOM;

use_ok 'Yetie::Form::FieldSet';

my $t = Test::Mojo->new('App');
my $c = $t->app->build_controller;

use_ok 'Yetie::Form::FieldSet::Test';
my $fs = Yetie::Form::FieldSet::Test->new( controller => $c );

subtest 'attributes' => sub {
    ok( $fs->can($_), "right $_" ) for qw(controller schema);
    isa_ok $fs->validation, 'Mojolicious::Validator::Validation';
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

    # Module base import
    is_deeply Test::Form::FieldSet::Foo->field_info,
      {
        aa => {},
        bb => {},
        cc => {},
      },
      'right import all';
    is_deeply Test::Form::FieldSet::Bar->field_info, { bb => {} }, 'right import';
    is_deeply Test::Form::FieldSet::Buzz->field_info, {}, 'right not import';
    is_deeply Test::Form::FieldSet::Qux->field_info,
      {
        bb => {},
        ff => {},
      },
      'right import from inherit module';
};

subtest 'field' => sub {
    my $f = $fs->field('email');
    isa_ok $f, 'Yetie::Form::Field';
};

subtest 'field_info' => sub {
    my $info = Yetie::Form::FieldSet::Test->field_info('name');
    is_deeply $info,
      {
        type     => 'text',
        required => 1
      },
      'right field info';
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

subtest 'has_data' => sub {
    my $c = $t->app->build_controller;
    my $fs = Yetie::Form::FieldSet::Test->new( controller => $c );
    is $fs->has_data, '', 'right has not data';

    # Create new request
    $c = $t->app->build_controller;
    $fs = Yetie::Form::FieldSet::Test->new( controller => $c );
    $c->req->params->pairs( [ email => 'a@b.c', ] );
    is $fs->has_data, 1, 'right has data';
};

subtest 'parameters' => sub {
    my $c = $t->app->build_controller;
    my $fs = Yetie::Form::FieldSet::Test->new( controller => $c );
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

    # to_hash
    my $params = $fs->params->to_hash;
    is_deeply $params->{'favorite_color[]'}, ['red'], 'right every param to_hash';
};

subtest 'render tags' => sub {
    ok !$fs->render_error('email');
    is ref $fs->render_help('email'),  'Mojo::ByteStream', 'right render_help method';
    is ref $fs->render_label('email'), 'Mojo::ByteStream', 'right render_label method';
    is ref $fs->render('email'),       'Mojo::ByteStream', 'right render method';

    my $fs = Yetie::Form::FieldSet::Test->new( controller => $c );
};

subtest 'render tags with attrs' => sub {
    my $fs = Yetie::Form::FieldSet::Test->new( controller => $c );
    my $dom = Mojo::DOM->new( $fs->render('email') );
    is_deeply $dom->at('*')->attr->{value},       undef,         'right value';
    is_deeply $dom->at('*')->attr->{placeholder}, 'name@domain', 'right placeholder';

    $fs = Yetie::Form::FieldSet::Test->new( controller => $c );
    $dom = Mojo::DOM->new( $fs->render( 'email', value => 'foo', placeholder => 'bar' ) );
    is_deeply $dom->at('*')->attr->{value},       'foo', 'right value';
    is_deeply $dom->at('*')->attr->{placeholder}, 'bar', 'right placeholder';
};

subtest 'schema' => sub {
    my $schema = $fs->schema;
    is ref $schema, 'HASH';
    my $field_schema = $fs->schema('email');
    is ref $field_schema, 'HASH';
};

subtest 'validate' => sub {
    my $c = $t->app->build_controller;
    my $fs = Yetie::Form::FieldSet::Test->new( controller => $c );
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
    $fs = Yetie::Form::FieldSet::Test->new( controller => $c );
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
    my $c = $t->app->build_controller;
    my $fs = Yetie::Form::FieldSet::Test->new( controller => $c );
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
    $fs->append_field( aaa => ( type => 'text' ) );
    my @field_keys = $fs->field_keys;
    is_deeply \@field_keys, [qw/email name address favorite_color luky_number item.[].id item.[].name aaa/],
      'right field_keys';

    # Hash refference
    $fs->append_field( bbb => { type => 'choice' } );
    @field_keys = $fs->field_keys;
    is_deeply \@field_keys, [qw/email name address favorite_color luky_number item.[].id item.[].name aaa bbb/],
      'right field_keys';
    is_deeply $fs->schema('bbb'), { type => 'choice' }, 'right schema';

    $fs->remove('name');
    @field_keys = $fs->field_keys;
    is_deeply \@field_keys, [qw/email address favorite_color luky_number item.[].id item.[].name aaa bbb/],
      'right field_keys';
};

done_testing();

package Test::Form::FieldSet::Foo;
use Test::Form::FieldSet::Base -all;
1;

package Test::Form::FieldSet::Bar;
use Test::Form::FieldSet::Base qw(bb);
1;

package Test::Form::FieldSet::Buzz;
use Test::Form::FieldSet::Base;
1;

package Test::Form::FieldSet::Qux;
use Test::Form::FieldSet::Common qw(bb ff);
1;
