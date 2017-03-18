use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

subtest 'basic' => sub {
    use_ok 'Markets::Domain::Factory';
    my $obj =
      Markets::Domain::Factory->new( { construct_class => 'Markets::Domain::Entity::Hoge' } );
    isa_ok $obj, 'Markets::Domain::Entity::Hoge', 'right construct object';
};

subtest 'construct method nothing' => sub {
    my $obj = Markets::Domain::Factory::Entity::Hoge->new(
        { construct_class => 'Markets::Domain::Entity::Hoge' } );
    isa_ok $obj, 'Markets::Domain::Entity::Hoge', 'right construct object';
    is $obj->{hoge}, undef, 'right attributes';
};

subtest 'construct method' => sub {
    my $obj = Markets::Domain::Factory::Entity::Fuga->new(
        { construct_class => 'Markets::Domain::Entity::Fuga' } );
    isa_ok $obj, 'Markets::Domain::Entity::Fuga', 'right construct object';
    is $obj->{fuga}, 1, 'right attributes';
};

subtest 'factory helper' => sub {

    isa_ok $app->factory('entity-nofactory'), 'Markets::Domain::Entity::Nofactory';

    my $obj = $app->factory('entity-bar');
    isa_ok $obj, 'Markets::Domain::Entity::Bar';
    isa_ok $obj->{hoge}, 'Markets::Domain::Entity::Hoge';
};

done_testing();

{

    package Markets::Domain::Factory::Entity::Hoge;
    use Mojo::Base 'Markets::Domain::Factory';
    1;

    package Markets::Domain::Entity::Hoge;
    use Mojo::Base 'Markets::Domain::Entity';
    1;
}

{

    package Markets::Domain::Factory::Entity::Fuga;
    use Mojo::Base 'Markets::Domain::Factory';

    sub construct {
        my $self = shift;
        $self->construct_class->new( fuga => 1 );
    }
    1;

    package Markets::Domain::Entity::Fuga;
    use Mojo::Base 'Markets::Domain::Entity';
    1;
}

{

    package Markets::Domain::Entity::Nofactory;
    use Mojo::Base 'Markets::Domain::Entity';
    1;
}

{

    package Markets::Domain::Factory::Entity::Bar;
    use Mojo::Base 'Markets::Domain::Factory';

    sub construct {
        my $self = shift;
        my $hoge = $self->app->factory('entity-hoge');
        $self->construct_class->new( hoge => $hoge );
    }
    1;

    package Markets::Domain::Entity::Bar;
    use Mojo::Base 'Markets::Domain::Entity';
    1;
}
