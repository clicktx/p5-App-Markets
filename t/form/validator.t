use Mojo::Base -strict;
use Test::More;
use Test::Mojo;
use t::Util;
use Yetie::Form::FieldSet;

use_ok 'Yetie::Form::Validator';

my $t = Test::Mojo->new('App');

sub new_req {
    my $c = $t->app->build_controller;
    my $f = Yetie::Form::FieldSet->new( controller => $c );
    my $v = $c->validation;
    return ( $c, $f, $v );
}

subtest 'required' => sub {
    my ( $c, $f, $v ) = new_req();
    $f->append_field( 'foo' => ( required => 1 ) );
    $v->input( { foo => undef } );
    $f->validate;
    is $v->error('foo')->[0], 'required', 'right invalid';
    ok $v->error_message('foo'), 'right error message';

    ( $c, $f, $v ) = new_req();
    $f->append_field( 'foo' => () );
    $v->input( { foo => undef } );
    $f->validate;
    is $v->error('foo'), undef, 'right valid';
};

subtest 'ascii' => sub {
    my ( $c, $f, $v ) = new_req();
    $f->append_field( 'foo' => ( validations => ['ascii'] ) );
    $v->input( { foo => 'あ' } );
    $f->validate;
    is $v->error('foo')->[0], 'ascii', 'right invalid';
    ok $v->error_message('foo'), 'right error message';
};

subtest 'int' => sub {
    my ( $c, $f, $v ) = new_req();
    $f->append_field( 'foo' => ( validations => ['int'] ) );
    $v->input( { foo => 'a' } );
    $f->validate;
    is $v->error('foo')->[0], 'int', 'right invalid';
    ok $v->error_message('foo'), 'right error message';

    ( $c, $f, $v ) = new_req();
    $v->input( { foo => 3.2 } );
    $f->validate;
    is $v->error('foo')->[0], 'int', 'right invalid';

    ( $c, $f, $v ) = new_req();
    $v->input( { foo => 5 } );
    $f->validate;
    is $v->error('foo'), undef, 'right valid';
};

subtest 'length' => sub {
    my ( $c, $f, $v ) = new_req();
    $f->append_field( 'foo' => ( validations => [ [ 'length' => 3, 5 ] ] ) );
    $v->input( { foo => 'a' } );
    $f->validate;
    is $v->error('foo')->[0], 'length', 'right invalid';
    ok $v->error_message('foo'), 'right error message';

    ( $c, $f, $v ) = new_req();
    $v->input( { foo => 'abcdef' } );
    $f->validate;
    is $v->error('foo')->[0], 'length', 'right invalid';

    ( $c, $f, $v ) = new_req();
    $v->input( { foo => 'abcd' } );
    $f->validate;
    is $v->error('foo'), undef, 'right valid';

    $f->append_field( 'foo' => ( validations => [ [ 'length' => 4 ] ] ) );
    ( $c, $f, $v ) = new_req();
    $v->input( { foo => 'a' } );
    $f->validate;
    is $v->error('foo')->[0], 'length', 'right invalid';

    ( $c, $f, $v ) = new_req();
    $v->input( { foo => 'abcdef' } );
    $f->validate;
    is $v->error('foo')->[0], 'length', 'right invalid';

    ( $c, $f, $v ) = new_req();
    $v->input( { foo => 'abcd' } );
    $f->validate;
    is $v->error('foo'), undef, 'right valid';
};

subtest 'number' => sub {
    my ( $c, $f, $v ) = new_req();
    $f->append_field( 'foo' => ( validations => ['number'] ) );
    $f->append_field( 'bar' => ( validations => ['number'] ) );
    $v->input( { foo => '1 000 000,00', bar => '5,5' } );
    $f->validate;
    is $v->error('foo')->[0], 'number', 'right invalid';
    is $v->error('bar')->[0], 'number', 'right invalid';
    ok $v->error_message('foo'), 'right error message';

    ( $c, $f, $v ) = new_req();
    $v->input( { foo => '1,000,000.00', bar => '5.5' } );
    $f->validate;
    is $v->error('foo'), undef, 'right valid';
    is $v->error('bar'), undef, 'right valid';

    # Locale: RU (Russian; русский язык) / FR (French; français)
    $t->app->pref( locale_country => 'RU' );
    $t->app->plugin('Yetie::Form');

    ( $c, $f, $v ) = new_req();
    $v->input( { foo => '1 000 000,00', bar => '5,5' } );
    $f->validate;
    is $v->error('foo'), undef, 'right valid';
    is $v->error('bar'), undef, 'right valid';

    # Locale: DE (German, Deutsch)
    $t->app->pref( locale_country => 'DE' );
    $t->app->plugin('Yetie::Form');

    ( $c, $f, $v ) = new_req();
    $v->input( { foo => '1.000.000,00', bar => '5,5' } );
    $f->validate;
    is $v->error('foo'), undef, 'right valid';
    is $v->error('bar'), undef, 'right valid';
};

subtest 'range' => sub {
    my ( $c, $f, $v ) = new_req();
    $f->append_field( 'foo' => ( validations => [ [ 'range' => 3, 5 ] ] ) );
    $v->input( { foo => 2 } );
    $f->validate;
    is $v->error('foo')->[0], 'range', 'right invalid';
    ok $v->error_message('foo'), 'right error message';

    ( $c, $f, $v ) = new_req();
    $v->input( { foo => 6 } );
    $f->validate;
    is $v->error('foo')->[0], 'range', 'right invalid';

    ( $c, $f, $v ) = new_req();
    $v->input( { foo => 3 } );
    $f->validate;
    is $v->error('foo'), undef, 'right valid';
};

subtest 'uint' => sub {
    my ( $c, $f, $v ) = new_req();
    $f->append_field( 'foo' => ( validations => ['uint'] ) );
    $v->input( { foo => 'a' } );
    $f->validate;
    is $v->error('foo')->[0], 'uint', 'right invalid';
    ok $v->error_message('foo'), 'right error message';

    ( $c, $f, $v ) = new_req();
    $v->input( { foo => 3.2 } );
    $f->validate;
    is $v->error('foo')->[0], 'uint', 'right invalid';

    ( $c, $f, $v ) = new_req();
    $v->input( { foo => -5 } );
    $f->validate;
    is $v->error('foo')->[0], 'uint', 'right invalid';

    ( $c, $f, $v ) = new_req();
    $v->input( { foo => 5 } );
    $f->validate;
    is $v->error('foo'), undef, 'right valid';
};

done_testing();
