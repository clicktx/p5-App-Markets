use Mojo::Base -strict;
use Test::More;
use Test::Deep;
use DateTime;

subtest 'basic' => sub {
    use_ok 'Yetie::Domain::Factory';
    my $f   = Yetie::Domain::Factory->new('entity-hoge');
    my $e_c = 'Yetie::Domain::Entity::Hoge';

    # params method
    my $p = $f->params;
    is_deeply $p, { entity_class => $e_c }, 'right get params empty hash ref';
    my %p = $f->params;
    is_deeply \%p, { entity_class => $e_c }, 'right get params empty hash';

    $f->params( a => 1 );
    $f->params( b => 2 );
    is_deeply $f, { a => 1, b => 2, entity_class => $e_c }, 'right set params';

    $p = $f->params;
    is_deeply $p, { a => 1, b => 2, entity_class => $e_c }, 'right get hash reference';
    my %params = $f->params;
    is_deeply \%params, { a => 1, b => 2, entity_class => $e_c }, 'right get hash';

    $f->params( { c => 3, d => 4 } );
    is_deeply $f, { a => 1, b => 2, c => 3, d => 4, entity_class => $e_c }, 'right set params';

    eval { $f->params('a') };
    ok $@, 'getter only one argument';

    # param method
    $f->param( e => 5 );
    $f->param( { f => 6 } );
    is $f->param('e'), 5, 'right getter param';
    is $f->param('f'), 6, 'right getter param';

    eval { $f->param() };
    ok $@, 'no arguments';
    eval { $f->param( g => 7, h => 8 ) };
    ok $@, 'too many arguments';
    eval { $f->param( { g => 7, h => 8 } ) };
    ok $@, 'too many arguments';
};

subtest 'factory' => sub {
    my $app = bless {}, 'Test::App';
    my $f = Yetie::Domain::Factory->new('entity-hoge');
    $f->app($app);

    my $ff = $f->factory('entity-hoge');
    is ref $ff->app, 'Test::App', 'right attribute "app"';
};

subtest 'has not cook' => sub {
    my $f = Yetie::Domain::Factory->new('entity-hoge');
    is ref $f, 'Yetie::Domain::Factory::Hoge', 'right namespace';

    my $entity = $f->create_entity();
    is ref $entity, 'Yetie::Domain::Entity::Hoge', 'right namespace';
    cmp_deeply { %{$entity} }, {}, 'right argument empty';

    Yetie::Domain::Entity::Hoge->attr( [qw(hoge fuga)] );
    $f = Yetie::Domain::Factory->new( 'entity-hoge', hoge => 1 );
    $entity = $f->create_entity( fuga => 2 );
    cmp_deeply { %{$entity} }, { hoge => 1, fuga => 2 }, 'right argument Hash';

    $f = Yetie::Domain::Factory->new( 'entity-hoge', { hoge => 1 } );
    $entity = $f->create_entity( { fuga => 2 } );
    cmp_deeply { %{$entity} }, { hoge => 1, fuga => 2 }, 'right argument Hash reference';
};

subtest 'has cook' => sub {
    Yetie::Domain::Entity::Foo->attr( [qw(a b f h)] );
    my $f = Yetie::Domain::Factory->new('entity-foo');
    is ref $f, 'Yetie::Domain::Factory::Foo', 'right namespace';

    my $entity = $f->create_entity();
    is ref $entity, 'Yetie::Domain::Entity::Foo', 'right namespace';
    cmp_deeply { %{$entity} }, { a => 1, b => 2, f => 'fuga', h => 'hoge' }, 'right parameter';
};

subtest 'no factory' => sub {
    my $entity = Yetie::Domain::Factory->new('entity-nofactory')->create;
    is ref $entity, 'Yetie::Domain::Entity::Nofactory', 'right namespace';
    cmp_deeply { %{$entity} }, {}, 'right parameter';
    is $entity->text, 'no factory', 'right method';
};

subtest 'factory method using' => sub {
    Yetie::Domain::Entity::Bar->attr('hoge');
    my $f      = Yetie::Domain::Factory->new('entity-bar');
    my $entity = $f->create_entity();
    is ref $entity, 'Yetie::Domain::Entity::Bar', 'right namespace';
    cmp_deeply { %{$entity} }, { hoge => isa('Yetie::Domain::Entity::Hoge'), }, 'right parameter';
};

subtest 'aggregate method' => sub {
    Yetie::Domain::Entity::Agg->attr( [qw(hoges bars)] );

    my $f = Yetie::Domain::Factory->new('entity-agg');
    eval { $f->aggregate( 'hoges', 'entity-hoge', 'abc' ) };
    ok $@, 'bad data type';

    my $entity = $f->create;
    isa_ok $entity->hoges, 'Yetie::Domain::Collection', 'right aggregate array';
    isa_ok $entity->bars,  'Yetie::Domain::IxHash',     'right aggregate hash';
};

subtest 'inflate datetime for *_at' => sub {
    Yetie::Domain::Entity::Bar->attr( [qw(created_at)] );

    my $f = Yetie::Domain::Factory->new('entity-bar')->create( { created_at => '2017-5-26 19:17:06' } );
    isa_ok $f->{created_at}, 'DateTime';
    is $f->{created_at}->ymd, '2017-05-26', 'right date';

    my $datetime = DateTime->new(
        year      => 1964,
        month     => 10,
        day       => 16,
        hour      => 16,
        minute    => 12,
        second    => 47,
        time_zone => 'UTC',
    );
    $f = Yetie::Domain::Factory->new('entity-bar')->create( { created_at => $datetime } );
    isa_ok $f->{created_at}, 'DateTime';
    is $f->{created_at}->ymd, '1964-10-16', 'right date';
};

done_testing();

{

    package Yetie::Domain::Factory::Hoge;
    use Mojo::Base 'Yetie::Domain::Factory';

    package Yetie::Domain::Entity::Hoge;
    use Mojo::Base 'Yetie::Domain::Entity';
}

{

    package Yetie::Domain::Factory::Foo;
    use Mojo::Base 'Yetie::Domain::Factory';

    sub cook {
        my $self = shift;
        $self->params( f => 'fuga', h => 'hoge' );
        $self->params( { a => 1, b => 2 } );
    }

    package Yetie::Domain::Entity::Foo;
    use Mojo::Base 'Yetie::Domain::Entity';
}

{

    package Yetie::Domain::Entity::Nofactory;
    use Mojo::Base 'Yetie::Domain::Entity';
    sub text { 'no factory' }
}

{

    package Yetie::Domain::Factory::Bar;
    use Mojo::Base 'Yetie::Domain::Factory';

    sub cook {
        my $self = shift;
        my $hoge = $self->factory('entity-hoge')->create;
        $self->param( hoge => $hoge );
    }

    package Yetie::Domain::Entity::Bar;
    use Mojo::Base 'Yetie::Domain::Entity';
}

{

    package Yetie::Domain::Factory::Agg;
    use Mojo::Base 'Yetie::Domain::Factory';

    sub cook {
        my $self = shift;
        $self->aggregate( 'hoges', 'entity-hoge', [ {} ] );
        $self->aggregate_kvlist( 'bars', 'entity-bar', [ a => {} ] );
    }

    package Yetie::Domain::Entity::Agg;
    use Mojo::Base 'Yetie::Domain::Entity';
}
