use Mojo::Base -strict;
use Test::More;
use Test::Mojo;
use t::Util;

# my $f = 'Yetie::Validator::Filters';
# use_ok $f;
#
# subtest '_hyphen' => sub {
#     my $dash = 'ー˗‐‒–——−ｰ‑―﹘─━ー';
#     my $res = $f->_hyphen( undef, $dash );
#     is $res, '---------------', 'right convert to hypen';
# };

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

done_testing();
