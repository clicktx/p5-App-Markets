use Mojo::Base -strict;
use Test::More;
use Test::Mojo;
use t::Util;

use_ok 'Yetie::App::Core::Validator::Filters';
my $t = Test::Mojo->new('App');

sub new_req {
    my $c = $t->app->build_controller;
    my $v = $c->validation;
    return ( $c, $v );
}

subtest 'double_byte_char' => sub {
    my ( $c, $v ) = new_req();
    $v->input(
        { foo => '４２ Ｐｅｎｄｅｒｇａｓｔ Ｓｔ．！＠＃＄％＾＆＊（）＿＋＝，．？' } );
    $v->optional( 'foo', 'double_byte_char' );
    is $v->param('foo'), '42 Pendergast St.!@#$%^&*()_+=,.?', 'right double byte characters';
};

subtest 'hyphen' => sub {
    my ( $c, $v ) = new_req();
    $v->input( { foo => 'ー˗‐‒–——−ｰ‑―﹘─━ー' } );
    $v->optional( 'foo', 'hyphen' );
    is $v->param('foo'), '---------------', 'right convert hyphen';
};

subtest 'space' => sub {
    my ( $c, $v ) = new_req();
    $v->input(
        {
            foo => '  a  a  ',
            bar => "\x{3000}\x{3000}a\x{3000}\x{3000}a\x{3000}\x{3000}",
            baz => "\x{0009}\x{0009}a\x{0009}\x{0009}a\x{0009}\x{0009}",
        }
    );
    $v->optional( 'foo', 'space' );
    $v->optional( 'bar', 'space' );
    $v->optional( 'baz', 'space' );
    is $v->param('foo'), ' a a ', 'right space';
    is $v->param('bar'), ' a a ', 'right ideographic space';
    is $v->param('baz'), ' a a ', 'right tab';
};

done_testing();
