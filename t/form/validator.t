use Mojo::Base -strict;
use Test::More;
use Test::Mojo;
use t::Util;
use Markets::Form::FieldSet;

use_ok 'Markets::Form::Validator';

my $t = Test::Mojo->new('App');

sub new_req {
    my $c = $t->app->build_controller;
    my $f = Markets::Form::FieldSet->new( controller => $c );
    my $v = $c->validation;
    return ( $c, $f, $v );
}

subtest 'required' => sub {
    my ( $c, $f, $v ) = new_req();
    $f->append( 'foo' => ( required => 1 ) );
    $v->input( { foo => undef } );
    $f->validate;
    is $v->error('foo')->[0], 'required', 'right invalid';
    ok $v->error_message('foo'), 'right error message';

    ( $c, $f, $v ) = new_req();
    $f->append( 'foo' => () );
    $v->input( { foo => undef } );
    $f->validate;
    is $v->error('foo'), undef, 'right valid';
};

subtest 'length' => sub {
    my ( $c, $f, $v ) = new_req();
    $f->append( 'foo' => ( validations => [ [ 'length' => 3, 5 ] ] ) );
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

    $f->append( 'foo' => ( validations => [ [ 'length' => 4 ] ] ) );
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

subtest 'range' => sub {
    my ( $c, $f, $v ) = new_req();
    $f->append( 'foo' => ( validations => [ [ 'range' => 3, 5 ] ] ) );
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

done_testing();
