use Mojo::Base -strict;
use Test::More;
use Test::Mojo;
use t::Util;

use_ok 'Markets::Form::FieldSet';

my $t = Test::Mojo->new('App');
my $c = $t->app->build_controller;

use Markets::Form::Type::Test;
my $fs = Markets::Form::Type::Test->new( controller => $c );

# subtest 'each' => sub {
#     my @field_keys;
#     $fs->each( sub { push @field_keys, $a; isa_ok $b, 'Markets::Form::Field'; } );
#     is_deeply \@field_keys, [qw/email name address item.[].id/], 'right each field_keys';
# };

subtest 'attributes' => sub {
    ok( $fs->can($_), "right $_" ) for qw(controller params field_list);
};

subtest 'c' => sub {
    ok $fs->can('c');
    isa_ok $fs->c( 1, 2, 3 ), 'Mojo::Collection';
};

subtest 'field' => sub {
    my $f = $fs->field('email');
    isa_ok $f, 'Markets::Form::Field';
};

subtest 'field_keys' => sub {
    my @field_keys = $fs->field_keys;
    is_deeply \@field_keys, [qw/email name address item.[].id/], 'right field_keys';
    my $field_keys = $fs->field_keys;
    is ref $field_keys, 'ARRAY', 'right scalar';
};

subtest 'params' => sub {
    isa_ok $fs->params, 'Mojo::Parameters';
    $fs->params->append( email => 'a@b.com' );

    is $fs->params->param('email'), 'a@b.com', 'right get param';
    is $fs->params->param('a'),     undef,     'right empty param';
};

subtest 'render tags' => sub {
    is ref $fs->render('email'),       'CODE', 'right render method';
    is ref $fs->render_label('email'), 'CODE', 'right render_label method';
};

subtest 'validations' => sub {
    is_deeply $fs->validations('email'), [qw/email/], 'right get validations';
    is_deeply $fs->validations,
      {
        email        => [qw/email/],
        name         => [qw//],
        address      => [qw//],
        'item.[].id' => [qw//],
      },
      'right all field_key validations';
};

# This test should be done at the end!
subtest 'append/remove' => sub {
    $fs->append( aaa => ( type => 'text' ) );
    my @field_keys = $fs->field_keys;
    is_deeply \@field_keys, [qw/email name address item.[].id aaa/], 'right field_keys';

    $fs->remove('name');
    @field_keys = $fs->field_keys;
    is_deeply \@field_keys, [qw/email address item.[].id aaa/], 'right field_keys';
};

done_testing();
