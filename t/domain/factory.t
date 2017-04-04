use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Deep;
use Test::Mojo;

subtest 'basic' => sub {
    use_ok 'Markets::Domain::Factory';
    my $f = Markets::Domain::Factory->new;
    $f->params( a => 1, b => 2 );
    is_deeply $f, { a => 1, b => 2 }, 'right set params';

    my $params = $f->params;
    is_deeply $params, { a => 1, b => 2 }, 'right get reference';
    my %params = $f->params;
    is_deeply \%params, { a => 1, b => 2 }, 'right get hash';

    $f->params( { c => 3, d => 4 } );
    is_deeply $f, { a => 1, b => 2, c => 3, d => 4 }, 'right set param';
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

subtest 'factory helper' => sub {
    my $t      = Test::Mojo->new('App');
    my $app    = $t->app;
    my $entity = $app->factory('entity-bar')->create;
    isa_ok $entity, 'Markets::Domain::Entity::Bar';
    isa_ok $entity->{hoge}, 'Markets::Domain::Entity::Hoge';
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
        $self->params( hoge => $hoge );
    }

    package Markets::Domain::Entity::Bar;
    use Mojo::Base 'Markets::Domain::Entity';
}
