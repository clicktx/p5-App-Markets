use Mojo::Base -strict;
use Mojo::Collection qw(c);

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;
use_ok 'Yetie::Service::Form';

subtest 'fill_in' => sub {
    my $c = $app->build_controller;
    my $f = Yetie::Form::Base->new( 'test', controller => $c );
    my $e = Yetie::Domain::Factory->new('test')->create_entity();
    my $s = $c->service('form');

    # choice singular
    $f->field('favorite_color')->type('choice');
    $f->field('favorite_color')->multiple(0);
    $f->field('favorite_color')->expanded(0);
    $f->field('favorite_color')->choices( [qw(red green blue)] );
    $e->favorite_color('green');
    $s->fill_in( $f, $e );
    is_deeply $f->field('favorite_color')->choices, [ 'red', [ green => 'green', choiced => 1 ], 'blue' ],
      'right choice singular';

    $f->field('favorite_color')->choices( [ 'red', [ Green => 'green' ], 'blue' ] );
    $s->fill_in( $f, $e );
    is_deeply $f->field('favorite_color')->choices, [ 'red', [ Green => 'green', choiced => 1 ], 'blue' ],
      'right choice singular';

    $f->field('favorite_color')
      ->choices( [ c( Warm => [ [ Red => 'red' ], [ Yellow => 'yellow' ] ] ), c( Cool => [ 'green', 'blue' ] ) ] );
    $s->fill_in( $f, $e );
    is_deeply $f->field('favorite_color')->choices,
      [
        c( Warm => [ [ Red => 'red' ], [ Yellow => 'yellow' ] ] ),
        c( Cool => [ [ green => 'green', choiced => 1 ], 'blue' ] )
      ],
      'right choice singular';

    $f->field('favorite_color')
      ->choices( [ c( Warm => [ [ Red => 'red' ], [ Yellow => 'yellow' ] ] ), c( Cool => [ 'green', 'blue' ] ) ] );
    $e->favorite_color('yellow');
    $s->fill_in( $f, $e );
    is_deeply $f->field('favorite_color')->choices,
      [ c( Warm => [ [ Red => 'red' ], [ Yellow => 'yellow', choiced => 1 ] ] ), c( Cool => [ 'green', 'blue' ] ) ],
      'right choice singular';

    # choice multiple
    $f->field('favorite_color')->multiple(1);
    $f->field('favorite_color')->expanded(0);
    $f->field('favorite_color')->choices( [qw(red green blue)] );
    $e->favorite_color( [ 'green', 'blue' ] );
    $s->fill_in( $f, $e );
    is_deeply $f->field('favorite_color')->choices,
      [ 'red', [ green => 'green', choiced => 1 ], [ blue => 'blue', choiced => 1 ] ], 'right choice multiple';

    $f->field('favorite_color')->choices( [ 'red', [ Green => 'green' ], 'blue' ] );
    $s->fill_in( $f, $e );
    is_deeply $f->field('favorite_color')->choices,
      [ 'red', [ Green => 'green', choiced => 1 ], [ blue => 'blue', choiced => 1 ] ], 'right choice multiple';

    $f->field('favorite_color')
      ->choices( [ c( Warm => [ [ Red => 'red' ], [ Yellow => 'yellow' ] ] ), c( Cool => [ 'green', 'blue' ] ) ] );
    $s->fill_in( $f, $e );
    is_deeply $f->field('favorite_color')->choices,
      [
        c( Warm => [ [ Red => 'red' ], [ Yellow => 'yellow' ] ] ),
        c( Cool => [ [ green => 'green', choiced => 1 ], [ blue => 'blue', choiced => 1 ] ] )
      ],
      'right choice multiple';

    $f->field('favorite_color')
      ->choices( [ c( Warm => [ [ Red => 'red' ], [ Yellow => 'yellow' ] ] ), c( Cool => [ 'green', 'blue' ] ) ] );
    $e->favorite_color( [ 'yellow', 'green' ] );
    $s->fill_in( $f, $e );
    is_deeply $f->field('favorite_color')->choices,
      [
        c( Warm => [ [ Red => 'red' ], [ Yellow => 'yellow', choiced => 1 ] ] ),
        c( Cool => [ [ green => 'green', choiced => 1 ], 'blue' ] )
      ],
      'right choice multiple';

    # select
    $f->field('luky_number')->type('select');
    $f->field('luky_number')->choices( [qw(1 2 3)] );
    $e->luky_number(2);
    $s->fill_in( $f, $e );
    is_deeply $f->field('luky_number')->choices, [ 1, [ 2 => 2, choiced => 1 ], 3 ], 'right select';

    # radio
    $f->field('luky_number')->type('radio');
    $f->field('luky_number')->choices( [qw(1 2 3)] );
    $e->luky_number(2);
    $s->fill_in( $f, $e );
    is_deeply $f->field('luky_number')->choices, [ 1, [ 2 => 2, choiced => 1 ], 3 ], 'right radio';

    # checkbox
    $f->field('luky_number')->type('checkbox');
    $f->field('luky_number')->choices( [qw(1 2 3)] );
    $e->luky_number(2);
    $s->fill_in( $f, $e );
    is_deeply $f->field('luky_number')->choices, [ 1, [ 2 => 2, choiced => 1 ], 3 ], 'right checkbox';

    # exception
    $e->luky_number( c( 2, 3 ) );
    eval { $s->fill_in( $f, $e ) };
    ok $@, 'right exception';
};

done_testing();

__END__
