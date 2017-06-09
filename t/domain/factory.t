use Mojo::Base -strict;
use Test::More;
use Test::Deep;

subtest 'basic' => sub {
    use_ok 'Markets::Domain::Factory';
    my $f = Markets::Domain::Factory->new;

    # params method
    my $p = $f->params;
    is_deeply $p, {}, 'right get params empty hash ref';
    my %p = $f->params;
    is_deeply \%p, {}, 'right get params empty hash';

    $f->params( a => 1 );
    $f->params( b => 2 );
    is_deeply $f, { a => 1, b => 2 }, 'right set params';

    $p = $f->params;
    is_deeply $p, { a => 1, b => 2 }, 'right get hash reference';
    my %params = $f->params;
    is_deeply \%params, { a => 1, b => 2 }, 'right get hash';

    $f->params( { c => 3, d => 4 } );
    is_deeply $f, { a => 1, b => 2, c => 3, d => 4 }, 'right set params';

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

subtest 'factory method' => sub {
    my $f = Markets::Domain::Factory->factory('entity-hoge');
    isa_ok $f, 'Markets::Domain::Factory::Entity::Hoge';

    $f = Markets::Domain::Factory->factory('hoge');
    isa_ok $f, 'Markets::Domain::Factory::Entity::Hoge', 'not "entity-" prefix';

    $f = Markets::Domain::Factory->factory('entity-nofactory');
    isa_ok $f, 'Markets::Domain::Factory', 'right no factory';
};

subtest 'has not cook' => sub {
    my $f = Markets::Domain::Factory::Entity::Hoge->new();
    is ref $f, 'Markets::Domain::Factory::Entity::Hoge', 'right namespace';

    my $entity = $f->create_entity();
    is ref $entity, 'Markets::Domain::Entity::Hoge', 'right namespace';
    cmp_deeply { %{$entity} }, {}, 'right argument empty';

    $f = Markets::Domain::Factory::Entity::Hoge->new( hoge => 1 );
    $entity = $f->create_entity( fuga => 2 );
    cmp_deeply { %{$entity} }, { hoge => 1, fuga => 2 }, 'right argument Hash';

    $f = Markets::Domain::Factory::Entity::Hoge->new( { hoge => 1 } );
    $entity = $f->create_entity( { fuga => 2 } );
    cmp_deeply { %{$entity} }, { hoge => 1, fuga => 2 }, 'right argument Hash reference';
};

subtest 'has cook' => sub {
    my $f = Markets::Domain::Factory::Entity::Foo->new();
    is ref $f, 'Markets::Domain::Factory::Entity::Foo', 'right namespace';

    my $entity = $f->create_entity();
    is ref $entity, 'Markets::Domain::Entity::Foo', 'right namespace';
    cmp_deeply { %{$entity} }, { a => 1, b => 2, f => 'fuga', h => 'hoge' }, 'right parameter';
};

subtest 'no factory' => sub {
    my $entity = Markets::Domain::Factory->new->factory('entity-nofactory')->create;
    is ref $entity, 'Markets::Domain::Entity::Nofactory', 'right namespace';
    cmp_deeply { %{$entity} }, {}, 'right parameter';
    is $entity->text, 'no factory', 'right method';
};

subtest 'factory method using' => sub {
    my $f      = Markets::Domain::Factory::Entity::Bar->new();
    my $entity = $f->create_entity();
    is ref $entity, 'Markets::Domain::Entity::Bar', 'right namespace';
    cmp_deeply { %{$entity} }, { hoge => isa('Markets::Domain::Entity::Hoge'), }, 'right parameter';
};

# subtest 'has attributes' => sub {
#     my $entity = Markets::Domain::Factory->new->factory('entity-nofactory')->create( { a => 1, b => 2 } );
#     eval { is $entity->a, 1 };
#     eval { is $entity->b, 2 };
#     ok !$@;
# };

subtest 'aggregate method' => sub {
    my $f = Markets::Domain::Factory->new->factory('entity-agg');
    eval { $f->aggregate( 'hoges', 'entity-hoge', 'abc' ) };
    ok $@, 'bad data type';

    my $entity = $f->create;
    $entity->attr('hoges');
    $entity->attr('bars');
    isa_ok $entity->hoges, 'Markets::Domain::Collection', 'right aggregate array';
    isa_ok $entity->bars,  'Markets::Domain::IxHash',     'right aggregate hash';
};

subtest 'inflate datetime for *_at' => sub {
    my $f = Markets::Domain::Factory->new->factory('entity-bar')->create( { created_at => '2017-5-26 19:17:06' } );
    isa_ok $f->{created_at}, 'DateTime';
    is $f->{created_at}->ymd, '2017-05-26';
};

done_testing();

{

    package Markets::Domain::Factory::Entity::Hoge;
    use Mojo::Base 'Markets::Domain::Factory';

    package Markets::Domain::Entity::Hoge;
    use Mojo::Base 'Markets::Domain::Entity';
}

{

    package Markets::Domain::Factory::Entity::Foo;
    use Mojo::Base 'Markets::Domain::Factory';

    sub cook {
        my $self = shift;
        $self->params( f => 'fuga', h => 'hoge' );
        $self->params( { a => 1, b => 2 } );
    }

    package Markets::Domain::Entity::Foo;
    use Mojo::Base 'Markets::Domain::Entity';
}

{

    package Markets::Domain::Entity::Nofactory;
    use Mojo::Base 'Markets::Domain::Entity';
    sub text { 'no factory' }
}

{

    package Markets::Domain::Factory::Entity::Bar;
    use Mojo::Base 'Markets::Domain::Factory';

    sub cook {
        my $self = shift;
        my $hoge = $self->factory('entity-hoge')->create;
        $self->param( hoge => $hoge );
    }

    package Markets::Domain::Entity::Bar;
    use Mojo::Base 'Markets::Domain::Entity';
}

{

    package Markets::Domain::Factory::Entity::Agg;
    use Mojo::Base 'Markets::Domain::Factory';

    sub cook {
        my $self = shift;
        $self->aggregate( 'hoges', 'entity-hoge', [ {} ] );
        $self->aggregate_kvlist( 'bars', 'entity-bar', [ a => {} ] );
    }

    package Markets::Domain::Entity::Agg;
    use Mojo::Base 'Markets::Domain::Entity';
}
