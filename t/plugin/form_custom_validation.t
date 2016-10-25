use Mojo::Base -strict;
use Mojolicious::Lite;

use Test::Mojo;
use Test::More;

plugin 'Markets::Plugin::LocaleTextDomainOO';
plugin 'Markets::Plugin::Form';

post '/required' => sub {
    my $c = shift;
    my $f = $c->form('cart');
    $f->add_field( 'id', [], ['required'] );

    my $json = { valid => $f->valid, errors => $f->errors };
    $c->render( json => $json );
};
post '/min' => sub {
    my $c = shift;
    my $f = $c->form('cart');
    $f->add_field( 'id', [], [ { min => 5 } ] );

    my $json = { valid => $f->valid, errors => $f->errors };
    $c->render( json => $json );
};
post '/max' => sub {
    my $c = shift;
    my $f = $c->form('cart');
    $f->add_field( 'id', [], [ { max => 5 } ] );

    my $json = { valid => $f->valid, errors => $f->errors };
    $c->render( json => $json );
};
post '/range' => sub {
    my $c = shift;
    my $f = $c->form('cart');
    $f->add_field( 'id', [], [ { range => [ 5, 10 ] } ] );

    my $json = { valid => $f->valid, errors => $f->errors };
    $c->render( json => $json );
};
post '/number/:lang' => sub {
    my $c = shift;
    my $lang = $c->stash('lang') || 'en';
    $c->language($lang);

    my $f = $c->form('cart');
    $f->add_field( 'id', [], ['number'] );

    my $json = { valid => $f->valid, errors => $f->errors };
    $c->render( json => $json );
};
post '/digits' => sub {
    my $c = shift;
    my $f = $c->form('cart');
    $f->add_field( 'id', [], ['digits'] );

    my $json = { valid => $f->valid, errors => $f->errors };
    $c->render( json => $json );
};

my $t = Test::Mojo->new;
$t->post_ok( '/required', form => { 'cart.id' => '' } )->status_is(200)
  ->json_is( { valid => 0, errors => { id => 'Required' } } );

# is_minimal
$t->post_ok( '/min', form => { 'cart.id' => 4 } )->status_is(200)->json_is(
    {
        valid  => 0,
        errors => { id => 'Enter a value greater than or equal to 5' }
    }
);
$t->post_ok( '/min', form => { 'cart.id' => 5 } )->status_is(200)
  ->json_is( { valid => 1, errors => {} } );

# is_maximum
$t->post_ok( '/max', form => { 'cart.id' => 6 } )->status_is(200)->json_is(
    {
        valid  => 0,
        errors => { id => 'Enter a value less than or equal to 5' }
    }
);
$t->post_ok( '/max', form => { 'cart.id' => 5 } )->status_is(200)
  ->json_is( { valid => 1, errors => {} } );

# is_range
$t->post_ok( '/range', form => { 'cart.id' => 4 } )->status_is(200)->json_is(
    {
        valid  => 0,
        errors => { id => 'Enter a value between 5 and 10' }
    }
);
$t->post_ok( '/range', form => { 'cart.id' => 11 } )->status_is(200)->json_is(
    {
        valid  => 0,
        errors => { id => 'Enter a value between 5 and 10' }
    }
);
$t->post_ok( '/range', form => { 'cart.id' => 5 } )->status_is(200)
  ->json_is( { valid => 1, errors => {} } );
$t->post_ok( '/range', form => { 'cart.id' => 10 } )->status_is(200)
  ->json_is( { valid => 1, errors => {} } );

# is_number
$t->post_ok( '/number/en', form => { 'cart.id' => 'a' } )->status_is(200)
  ->json_is( { valid => 0, errors => { id => 'Invalid number' } } );
$t->post_ok( '/number/en', form => { 'cart.id' => '' } )->status_is(200)
  ->json_is( { valid => 1, errors => {} } );
$t->post_ok( '/number/en', form => { 'cart.id' => 5 } )->status_is(200)
  ->json_is( { valid => 1, errors => {} } );
$t->post_ok( '/number/en', form => { 'cart.id' => '-55' } )->status_is(200)
  ->json_is( { valid => 1, errors => {} } );
$t->post_ok( '/number/en', form => { 'cart.id' => '5.5' } )->status_is(200)
  ->json_is( { valid => 1, errors => {} } );
$t->post_ok( '/number/en', form => { 'cart.id' => '1,000,000' } )
  ->status_is(200)->json_is( { valid => 1, errors => {} } );

# Locale: DE (German, Deutsch)
$t->post_ok( '/number/de', form => { 'cart.id' => '5,5' } )->status_is(200)
  ->json_is( { valid => 1, errors => {} } );
$t->post_ok( '/number/de', form => { 'cart.id' => '1.000.000,00' } )
  ->status_is(200)->json_is( { valid => 1, errors => {} } );

# Locale: RU (Russian; русский язык) / FR (French; français)
$t->post_ok( '/number/ru', form => { 'cart.id' => '5,5' } )->status_is(200)
  ->json_is( { valid => 1, errors => {} } );
$t->post_ok( '/number/ru', form => { 'cart.id' => '1 000 000,00' } )
  ->status_is(200)->json_is( { valid => 1, errors => {} } );

# is_digits
$t->post_ok( '/digits', form => { 'cart.id' => 'a' } )->status_is(200)
  ->json_is( { valid => 0, errors => { id => 'Only digits' } } );
$t->post_ok( '/digits', form => { 'cart.id' => '1.1' } )->status_is(200)
  ->json_is( { valid => 0, errors => { id => 'Only digits' } } );
$t->post_ok( '/digits', form => { 'cart.id' => '-5' } )->status_is(200)
  ->json_is( { valid => 0, errors => { id => 'Only digits' } } );
$t->post_ok( '/digits', form => { 'cart.id' => '' } )->status_is(200)
  ->json_is( { valid => 1, errors => {} } );
$t->post_ok( '/digits', form => { 'cart.id' => 5 } )->status_is(200)
  ->json_is( { valid => 1, errors => {} } );

done_testing();
