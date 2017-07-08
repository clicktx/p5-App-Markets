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
    is $v->error('foo')->[0], 'required', 'right required invalid';

    ( $c, $f, $v ) = new_req();
    $f->append( 'foo' => () );
    $v->input( { foo => undef } );
    $f->validate;
    is $v->error('foo'), undef, 'right valid';
};

done_testing();
