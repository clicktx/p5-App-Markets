use Mojo::Base -strict;
use Test::More;
use Test::Deep;
use Test::Exception;

subtest 'basic' => sub {
    {

        package Yetie::Domain::List::Items;
        use Moose;
        extends 'Yetie::Domain::List';

        package Yetie::Domain::Set::Pref;
        use Moose;
        extends 'Yetie::Domain::Set';
    }

    use_ok 'Yetie::Factory';
    my $f   = Yetie::Factory->new('entity-hoge');
    my $e_c = 'Yetie::Domain::Entity::Hoge';

    # params method
    my $p = $f->params;
    is_deeply $p, { domain_class => $e_c }, 'right get params empty hash ref';
    my %p = $f->params;
    is_deeply \%p, { domain_class => $e_c }, 'right get params empty hash';

    $f->params( a => 1 );
    $f->params( b => 2 );
    is_deeply $f, { a => 1, b => 2, domain_class => $e_c }, 'right set params';

    $p = $f->params;
    is_deeply $p, { a => 1, b => 2, domain_class => $e_c }, 'right get hash reference';
    my %params = $f->params;
    is_deeply \%params, { a => 1, b => 2, domain_class => $e_c }, 'right get hash';

    $f->params( { c => 3, d => 4 } );
    is_deeply $f, { a => 1, b => 2, c => 3, d => 4, domain_class => $e_c }, 'right set params';

    dies_ok { $f->params('a') } 'getter only one argument';

    # param method
    $f->param( e => 5 );
    $f->param( { f => 6 } );
    is $f->param('e'), 5, 'right getter param';
    is $f->param('f'), 6, 'right getter param';

    dies_ok { $f->param() } 'no arguments';
    dies_ok { $f->param( g => 7, h => 8 ) } 'too many arguments';
    dies_ok { $f->param( { g => 7, h => 8 } ) } 'too many arguments';

    subtest 'list domain' => sub {
        my $f = Yetie::Factory->new('list-items');
        my $e = $f->construct( list => [ 1, 2, 3 ] );
        isa_ok $e->list, 'Yetie::Domain::Collection';
        is_deeply $e->list->to_data, [ 1, 2, 3 ], 'right list data';
    };

    subtest 'set domain' => sub {
        my $f = Yetie::Factory->new('set-pref');
        my $e = $f->construct( hash_set => [ { a => 1 }, { b => 2 }, { c => 3 } ] );

        isa_ok $e->hash_set, 'Yetie::Domain::IxHash';
        is_deeply $e->hash_set->to_data, { a => 1, b => 2, c => 3 }, 'right set data';
    };
};

subtest 'factory' => sub {
    my $app = bless {}, 'Test::App';
    my $f = Yetie::Factory->new('entity-hoge');
    $f->app($app);

    my $ff = $f->factory('entity-hoge');
    is ref $ff->app, 'Test::App', 'right attribute "app"';
};

subtest 'has not cook' => sub {
    {

        package Yetie::Factory::Entity::Hoge;
        use Mojo::Base 'Yetie::Factory';

        package Yetie::Domain::Entity::Hoge;
        use Moose;
        extends 'Yetie::Domain::Entity';
        has [qw(hoge fuga)] => ( is => 'rw' );

        package Yetie::Domain::Value::Fuga;
        use Moose;
        extends 'Yetie::Domain::Value';
    }

    my $f = Yetie::Factory->new('entity-hoge');
    is ref $f, 'Yetie::Factory::Entity::Hoge', 'right namespace';

    my $entity = $f->construct();
    is ref $entity, 'Yetie::Domain::Entity::Hoge', 'right namespace';
    cmp_deeply { %{$entity} }, { _hash_sum => ignore() }, 'right argument empty';

    $f = Yetie::Factory->new( 'entity-hoge', hoge => 1 );
    $entity = $f->construct( fuga => 2 );
    cmp_deeply { %{$entity} }, { _hash_sum => ignore(), hoge => 1, fuga => 2 }, 'right argument Hash';

    $f = Yetie::Factory->new( 'entity-hoge', { hoge => 1 } );
    $entity = $f->construct( { fuga => 2 } );
    cmp_deeply { %{$entity} }, { _hash_sum => ignore(), hoge => 1, fuga => 2 }, 'right argument Hash reference';

    my $v = Yetie::Domain::Value::Fuga->new();
    $f = Yetie::Factory->new( 'entity-hoge', { hoge => $v } );
    $entity = $f->construct( { fuga => $v } );
    isa_ok $entity->hoge, 'Yetie::Domain::Value::Fuga', 'right argument object';
    isa_ok $entity->fuga, 'Yetie::Domain::Value::Fuga', 'right argument object';
};

subtest 'has cook' => sub {
    {

        package Yetie::Factory::Entity::Foo;
        use Mojo::Base 'Yetie::Factory';

        sub cook {
            my $self = shift;
            $self->params( f => 'fuga', h => 'hoge' );
            $self->params( { a => 1, b => 2 } );
        }

        package Yetie::Domain::Entity::Foo;
        use Moose;
        extends 'Yetie::Domain::Entity';
        has [qw(a b f h)] => ( is => 'rw' );
    }

    my $f = Yetie::Factory->new('entity-foo');
    is ref $f, 'Yetie::Factory::Entity::Foo', 'right namespace';

    my $entity = $f->construct();
    is ref $entity, 'Yetie::Domain::Entity::Foo', 'right namespace';
    cmp_deeply { %{$entity} }, { _hash_sum => ignore(), a => 1, b => 2, f => 'fuga', h => 'hoge' }, 'right parameter';
};

subtest 'no factory' => sub {
    {

        package Yetie::Domain::Entity::Nofactory;
        use Moose;
        extends 'Yetie::Domain::Entity';
        sub text { 'no factory' }
    }

    my $entity = Yetie::Factory->new('entity-nofactory')->construct();
    is ref $entity, 'Yetie::Domain::Entity::Nofactory', 'right namespace';
    cmp_deeply { %{$entity} }, { _hash_sum => ignore() }, 'right parameter';
    is $entity->text, 'no factory', 'right method';
};

subtest 'factory method using' => sub {
    {

        package Yetie::Factory::Entity::Bar;
        use Mojo::Base 'Yetie::Factory';

        sub cook {
            my $self = shift;
            $self->aggregate( hoge => 'entity-hoge', {} );
        }

        package Yetie::Domain::Entity::Bar;
        use Moose;
        extends 'Yetie::Domain::Entity';
        has hoge => ( is => 'rw' );
    }

    my $f      = Yetie::Factory->new('entity-bar');
    my $entity = $f->construct();
    is ref $entity, 'Yetie::Domain::Entity::Bar', 'right namespace';
    cmp_deeply { %{$entity} }, { _hash_sum => ignore(), hoge => isa('Yetie::Domain::Entity::Hoge'), },
      'right parameter';
};

subtest 'aggregate method' => sub {
    {

        package Yetie::Factory::Entity::Agg;
        use Mojo::Base 'Yetie::Factory';

        package Yetie::Domain::Entity::Agg;
        use Moose;
        extends 'Yetie::Domain::Entity';
        has [qw(hoge fuga foos bars list hash_set)] => ( is => 'rw' );
    }

    my $f = Yetie::Factory->new('entity-agg');

    dies_ok { $f->aggregate_collection( 'foos', 'entity-foo', 'abc' ) } 'bad data type';
    dies_ok { $f->aggregate_ixhash( 'bars', 'entity-bar', 'abc' ) } 'bad data type';

    $f->aggregate( 'hoge', 'entity-hoge', {} );
    $f->aggregate( 'fuga', 'value-fuga', '' );
    $f->aggregate_collection( 'foos', 'entity-foo', [ {} ] );
    $f->aggregate_ixhash( 'bars', 'entity-bar', [ { a => {} } ] );

    my $entity = $f->construct();
    isa_ok $entity->hoge, 'Yetie::Domain::Entity';
    is_deeply $entity->hoge->to_data, {}, 'right aggregate entity object';

    isa_ok $entity->fuga, 'Yetie::Domain::Value';
    is_deeply $entity->fuga->value, '', 'right aggregate value object';

    isa_ok $entity->foos, 'Yetie::Domain::Collection';
    is_deeply $entity->foos->to_data, [ { a => 1, b => 2, f => 'fuga', h => 'hoge' } ], 'right aggregate array';

    isa_ok $entity->bars, 'Yetie::Domain::IxHash';
    is_deeply $entity->bars->to_data, { a => { hoge => {} } }, 'right aggregate hash';

    # aggregate domain list and set
    $f = Yetie::Factory->new(
        'entity-agg',
        list     => [ {} ],
        hash_set => [ { a => {} } ],
    );
    $f->aggregate_domain_list('entity-foo');
    $f->aggregate_domain_set('entity-bar');
    $entity = $f->construct();
    isa_ok $entity->list, 'Yetie::Domain::Collection';
    is_deeply $entity->list->to_data, [ { a => 1, b => 2, f => 'fuga', h => 'hoge' } ], 'right aggregate array';
    isa_ok $entity->hash_set, 'Yetie::Domain::IxHash';
    is_deeply $entity->hash_set->to_data, { a => { hoge => {} } }, 'right aggregate hash';

    subtest 'argment object' => sub {
        my $f = Yetie::Factory->new('entity-agg');

        $f->aggregate( 'hoge', 'entity-hoge', Yetie::Domain::Entity->new() );
        $f->aggregate( 'fuga', 'value-fuga',  Yetie::Domain::Value->new() );

        my $entity = $f->construct();
        isa_ok $entity->hoge, 'Yetie::Domain::Entity';
        isa_ok $entity->fuga, 'Yetie::Domain::Value';
    };
};

done_testing();
