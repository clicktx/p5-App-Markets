use Mojo::Base -strict;
use Test::More;
use Test::Deep;
use Mojo::Util qw/sha1_sum/;

my $pkg = 'Markets::Domain::Entity';
use_ok $pkg;

subtest 'basic' => sub {
    my $e = $pkg->new( id => 1, hoge => 1, fuga => 2 );
    cmp_deeply $e->to_hash, { hoge => 1, fuga => 2 }, 'right to_hash';

    is $e->hash_code, sha1_sum(1), 'right hash code';
    is $e->hash_code(2), sha1_sum(2), 'right hash code';

    $e->is_modified(3);
    is $e->is_modified, 1, 'right modified';

    $e->is_modified(0);
    is $e->is_modified, 0, 'right not modified';

    $e->id(1);
    is $e->is_modified, 0, 'right not modified of update attribute but no change value';

    $e->id(111);
    is $e->is_modified, 1, 'right modified of update attribute';
};

subtest 'clone' => sub {
    my $data = { id => 1, hoge => [ {}, {} ], fuga => { a => [ {}, {} ] } };
    my $e = $pkg->new($data);
    $e->is_modified(1);

    my $clone = $e->clone;
    is $clone->is_modified, 0, 'right modified flag';

    isnt $e, $clone, 'right clone';
    cmp_deeply $e->to_hash, $clone->to_hash, 'right clone data structure';

    isnt $e->{hoge}, $clone->{hoge}, 'right another reference';
    $e->{hoge}->[0] = '';
    cmp_deeply $clone->{hoge}->[0], +{}, 'right two dimensions';
    $e->{fuga}->{a}->[0] = { b => 1 };
    cmp_deeply $clone->{fuga}->{a}->[0], {}, 'right three dimensions';
};

subtest 'to_array method' => sub {
    my $data = { id => 1, hoge => 1, fuga => 2 };
    my $e = $pkg->new($data);
    cmp_deeply $e->to_array, [ [qw/fuga hoge/], [qw/2 1/] ], 'right to_array';
};

subtest 'Entity object base' => sub {
    my $e1   = Markets::Domain::Entity::Hoge->new( id => 1 );
    my $e1_1 = Markets::Domain::Entity::Hoge->new( id => 1 );
    my $e2   = Markets::Domain::Entity::Fuga->new( id => 2 );

    is $e1->id, 1, 'right entity id';
    is $e1->is_equal($e1_1), 1, 'right equal object';
    is $e1->is_equal($e2),   0, 'right not equal object';
    is $e1->hash_code, '356a192b7913b04c54574d18c28d46e6395428ab', 'right hash code';

    $e1->id(1);
    is $e1->is_modified, 0, 'right not modified';
    $e1->id(111);
    is $e1->is_modified, 1, 'right modified';

    eval { Markets::Domain::Entity::Hoge->new->id };
    like $@, qr/Attribute "id" not implemented by subclass/, 'right not set entity id';
};

subtest 'to_data method' => sub {
    my $e = $pkg->new(
        a  => 1,
        b  => 2,
        h1 => $pkg->new(),
        h2 => $pkg->new(
            a => 1,
            h => $pkg->new( a => 1, b => 2 ),
        ),
    );

    cmp_deeply $e->to_data,
      {
        a  => 1,
        b  => 2,
        h1 => {},
        h2 => {
            a => 1,
            h => {
                a => 1,
                b => 2
            },
        },
      },
      'right dump data';
};

done_testing();

{

    package Markets::Domain::Entity::Hoge;
    use Markets::Domain::Entity;
}
{

    package Markets::Domain::Entity::Fuga;
    use Markets::Domain::Entity;
}
