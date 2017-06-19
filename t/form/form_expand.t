use Mojo::Base -strict;
use Mojolicious::Lite;

use Test::Mojo;
use Test::More;

plugin 'Markets::FormExpand';

post '/' => sub {
    my $c = shift;

    is $c->param('user'),       undef;
    is $c->field('cart.id'),    undef;
    is $c->param('csrf_token'), 'aaabbbccc';
    is $c->field('csrf_token'), 'aaabbbccc';

    is_deeply $c->field('user'), [ { name => 'francis' }, { name => 'claire' } ];
    is_deeply $c->field('cart'), { id => 123, item => '  hoge  ' };

    my $field = $c->field('user');
    is $field->[0]->{name}, 'francis';

    $c->render( json => {} );
};

my $t = Test::Mojo->new;
$t->post_ok(
    '/',
    form => {
        csrf_token    => 'aaabbbccc',
        'user.0.name' => 'francis',
        'user.1.name' => 'claire',
        'cart.id'     => '123',
        'cart.item'   => '  hoge  ',
    }
)->status_is(200);

done_testing();
