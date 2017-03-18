use Mojo::Base -strict;
use Test::More;

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

done_testing();

package Markets::Domain::Factory::Entity::Hoge;
use Mojo::Base 'Markets::Domain::Factory';
1;

package Markets::Domain::Factory::Entity::Fuga;
use Mojo::Base 'Markets::Domain::Factory';

sub construct {
    my $self = shift;
    $self->construct_class->new( fuga => 1 );
}
1;

package Markets::Domain::Entity::Hoge;
use Mojo::Base 'Markets::Domain::Entity';
1;

package Markets::Domain::Entity::Fuga;
use Mojo::Base 'Markets::Domain::Entity';
1;
