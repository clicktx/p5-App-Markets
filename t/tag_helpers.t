use Mojo::Base -strict;
use Test::More;
use Test::Mojo;
use Mojo::DOM;
use t::Util;

my $t = Test::Mojo->new('App');

subtest 'submit_button' => sub {
    my $c   = $t->app->build_controller;
    my $dom = Mojo::DOM->new( $c->submit_button() );
    is_deeply $dom->at('*')->attr, { value => 'Ok', type => 'submit' }, 'right default';

    $dom = Mojo::DOM->new( $c->submit_button( 'foo', type => 'button' ) );
    is_deeply $dom->at('*')->attr, { value => 'foo', type => 'button' }, 'right specify type';
};

done_testing();
