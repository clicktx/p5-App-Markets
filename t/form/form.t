use Mojo::Base -strict;
use Mojolicious::Lite;

use Test::Mojo;
use Test::More;

plugin 'Markets::I18N';
plugin 'Markets::Form';

post '/' => sub {
    my $c = shift;
    my $f = $c->form('cart');

    # alias methods
    is ref $f->c, 'Mojolicious::Controller', 'c method';

    # add/remove field
    $f->add_field('fuga');
    $f->remove_field('fuga');
    is_deeply $f->{field}, {}, 'remove field';

    $f->add_field( 'id', [], ['required'] );
    $f->add_field( 'item', ['trim'], ['required'] );
    is_deeply $f->{field},
      {
        id   => { filters => [],       validations => ['required'] },
        item => { filters => ['trim'], validations => ['required'] },
      },
      'add field';

    # default value
    $f->default_value( id => 123 );
    is $f->{default_value}->{id}, 123, 'default value';

    # param(before filter)
    is $f->param('item'), '  hoge  ', 'param before filter';

    # valid
    my $valid  = $f->valid;
    my $errors = $f->errors;
    is $valid, 0, 'valid mehod';

    # errors
    is_deeply $errors, { id => 'Required' }, 'errors all messages';
    is $f->errors('id'), 'Required', 'errors id';

    # params/param(after filter)
    is_deeply $f->params,
      {
        id   => '',
        item => 'hoge',
      },
      'params after filter';
    is $f->param('item'), 'hoge', 'param after filter';

    my $json = { valid => $valid, errors => $errors };
    $c->render( json => $json );
};

my $t = Test::Mojo->new;
$t->post_ok( '/', form => { 'cart.id' => '', 'cart.item' => '  hoge  ' } )
  ->status_is(200)->json_is( { valid => 0, errors => { id => 'Required' } } );

done_testing();
