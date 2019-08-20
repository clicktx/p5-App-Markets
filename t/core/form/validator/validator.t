use Mojo::Base -strict;
use Test::More;
use Test::Mojo;
use t::Util;
use Yetie::Form::Base;

use_ok 'Yetie::App::Core::Validator';

my $t = Test::Mojo->new('App');

sub new_req {
    my $c = $t->app->build_controller;
    my $f = Yetie::Form::Base->new( 'test', controller => $c );
    my $v = $c->validation;
    return ( $c, $f, $v );
}

subtest 'required' => sub {
    my ( $c, $f, $v ) = new_req();
    $f->fieldset->append_field( 'foo' => ( required => 1 ) );
    $v->input( { foo => undef } );
    $f->do_validate;
    is $v->error('foo')->[0], 'required', 'right invalid';
    ok $v->error_message('foo'), 'right error message';

    ( $c, $f, $v ) = new_req();
    $f->fieldset->append_field( 'foo' => () );
    $v->input( { foo => undef } );
    $f->do_validate;
    is $v->error('foo'), undef, 'right valid';
};

subtest 'ascii' => sub {
    my ( $c, $f, $v ) = new_req();
    $f->fieldset->append_field( 'foo' => ( validations => ['ascii'] ) );
    $v->input( { foo => 'あ' } );
    $f->do_validate;
    is $v->error('foo')->[0], 'ascii', 'right invalid';
    ok $v->error_message('foo'), 'right error message';
};

subtest 'int' => sub {
    my ( $c, $f, $v ) = new_req();
    $f->fieldset->append_field( 'foo' => ( validations => ['int'] ) );
    $v->input( { foo => 'a' } );
    $f->do_validate;
    is $v->error('foo')->[0], 'int', 'right invalid';
    ok $v->error_message('foo'), 'right error message';

    ( $c, $f, $v ) = new_req();
    $v->input( { foo => 3.2 } );
    $f->do_validate;
    is $v->error('foo')->[0], 'int', 'right invalid';

    ( $c, $f, $v ) = new_req();
    $v->input( { foo => 5 } );
    $f->do_validate;
    is $v->error('foo'), undef, 'right valid';
};

subtest 'length' => sub {
    my ( $c, $f, $v ) = new_req();
    $f->fieldset->append_field( 'foo' => ( validations => [ [ 'length' => 3, 5 ] ] ) );
    $v->input( { foo => 'a' } );
    $f->do_validate;
    is $v->error('foo')->[0], 'length', 'right invalid';
    ok $v->error_message('foo'), 'right error message';

    ( $c, $f, $v ) = new_req();
    $v->input( { foo => 'abcdef' } );
    $f->do_validate;
    is $v->error('foo')->[0], 'length', 'right invalid';

    ( $c, $f, $v ) = new_req();
    $v->input( { foo => 'abcd' } );
    $f->do_validate;
    is $v->error('foo'), undef, 'right valid';

    $f->fieldset->append_field( 'foo' => ( validations => [ [ 'length' => 4 ] ] ) );
    ( $c, $f, $v ) = new_req();
    $v->input( { foo => 'a' } );
    $f->do_validate;
    is $v->error('foo')->[0], 'length', 'right invalid';

    ( $c, $f, $v ) = new_req();
    $v->input( { foo => 'abcdef' } );
    $f->do_validate;
    is $v->error('foo')->[0], 'length', 'right invalid';

    ( $c, $f, $v ) = new_req();
    $v->input( { foo => 'abcd' } );
    $f->do_validate;
    is $v->error('foo'), undef, 'right valid';
};

subtest 'max' => sub {
    my ( $c, $f, $v ) = new_req();
    $f->fieldset->append_field( 'foo' => ( validations => [ [ 'max' => 3 ] ] ) );
    $v->input( { foo => 4 } );
    $f->do_validate;
    is $v->error('foo')->[0], 'max', 'right invalid';
    ok $v->error_message('foo'), 'right error message';

    ( $c, $f, $v ) = new_req();
    $v->input( { foo => 3 } );
    $f->do_validate;
    is $v->error('foo'), undef, 'right valid';

    ( $c, $f, $v ) = new_req();
    $v->input( { foo => 2 } );
    $f->do_validate;
    is $v->error('foo'), undef, 'right valid';
};

subtest 'min' => sub {
    my ( $c, $f, $v ) = new_req();
    $f->fieldset->append_field( 'foo' => ( validations => [ [ 'min' => 3 ] ] ) );
    $v->input( { foo => 2 } );
    $f->do_validate;
    is $v->error('foo')->[0], 'min', 'right invalid';
    ok $v->error_message('foo'), 'right error message';

    ( $c, $f, $v ) = new_req();
    $v->input( { foo => 3 } );
    $f->do_validate;
    is $v->error('foo'), undef, 'right valid';

    ( $c, $f, $v ) = new_req();
    $v->input( { foo => 4 } );
    $f->do_validate;
    is $v->error('foo'), undef, 'right valid';
};

subtest 'number' => sub {
    my ( $c, $f, $v ) = new_req();
    $f->fieldset->append_field( 'foo' => ( validations => ['number'] ) );
    $f->fieldset->append_field( 'bar' => ( validations => ['number'] ) );
    $v->input( { foo => '1 000 000,00', bar => '5,5' } );
    $f->do_validate;
    is $v->error('foo')->[0], 'number', 'right invalid';
    is $v->error('bar')->[0], 'number', 'right invalid';
    ok $v->error_message('foo'), 'right error message';

    ( $c, $f, $v ) = new_req();
    $v->input( { foo => '1,000,000.00', bar => '5.5' } );
    $f->do_validate;
    is $v->error('foo'), undef, 'right valid';
    is $v->error('bar'), undef, 'right valid';

    # Locale: RU (Russian; русский язык) / FR (French; français)
    $t->app->pref( locale_country_code => 'RU' );
    $t->app->plugin('Yetie::App::Core::Form');

    ( $c, $f, $v ) = new_req();
    $v->input( { foo => '1 000 000,00', bar => '5,5' } );
    $f->do_validate;
    is $v->error('foo'), undef, 'right valid';
    is $v->error('bar'), undef, 'right valid';

    # Locale: DE (German, Deutsch)
    $t->app->pref( locale_country_code => 'DE' );
    $t->app->plugin('Yetie::App::Core::Form');

    ( $c, $f, $v ) = new_req();
    $v->input( { foo => '1.000.000,00', bar => '5,5' } );
    $f->do_validate;
    is $v->error('foo'), undef, 'right valid';
    is $v->error('bar'), undef, 'right valid';
};

subtest 'range' => sub {
    my ( $c, $f, $v ) = new_req();
    $f->fieldset->append_field( 'foo' => ( validations => [ [ 'range' => 3, 5 ] ] ) );
    $v->input( { foo => 2 } );
    $f->do_validate;
    is $v->error('foo')->[0], 'range', 'right invalid';
    ok $v->error_message('foo'), 'right error message';

    ( $c, $f, $v ) = new_req();
    $v->input( { foo => 6 } );
    $f->do_validate;
    is $v->error('foo')->[0], 'range', 'right invalid';

    ( $c, $f, $v ) = new_req();
    $v->input( { foo => 3 } );
    $f->do_validate;
    is $v->error('foo'), undef, 'right valid';
};

subtest 'uint' => sub {
    my ( $c, $f, $v ) = new_req();
    $f->fieldset->append_field( 'foo' => ( validations => ['uint'] ) );
    $v->input( { foo => 'a' } );
    $f->do_validate;
    is $v->error('foo')->[0], 'uint', 'right invalid';
    ok $v->error_message('foo'), 'right error message';

    ( $c, $f, $v ) = new_req();
    $v->input( { foo => 3.2 } );
    $f->do_validate;
    is $v->error('foo')->[0], 'uint', 'right invalid';

    ( $c, $f, $v ) = new_req();
    $v->input( { foo => -5 } );
    $f->do_validate;
    is $v->error('foo')->[0], 'uint', 'right invalid';

    ( $c, $f, $v ) = new_req();
    $v->input( { foo => 5 } );
    $f->do_validate;
    is $v->error('foo'), undef, 'right valid';
};

done_testing();
