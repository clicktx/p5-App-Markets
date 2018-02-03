use Mojo::Base -strict;
use Test::More;
use Test::Deep;
use Mojo::Util qw/sha1_sum/;
use Yetie::Domain::Collection qw/collection/;
use Yetie::Domain::IxHash qw/ix_hash/;

my $pkg = 'Yetie::Domain::Entity';
use_ok $pkg;

subtest 'basic' => sub {
    $pkg->attr( [qw(hoge fuga)] );

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

    $e = $pkg->new( id => undef );
    is $e->hash_code, undef, 'right undefined id entity';
    is $e->hash_code(undef), undef, 'right undefined arg entity';
};

subtest 'function' => sub {
    my $c = collection( 1, 2, 3 );
    isa_ok $c, 'Yetie::Domain::Collection';
    is_deeply $c, [ 1, 2, 3 ], 'right deeply';

    my $h = ix_hash( a => 1, b => 2 );
    isa_ok $h, 'Yetie::Domain::IxHash';
    is_deeply $h, { a => 1, b => 2 }, 'right deeply';
};

subtest 'clone' => sub {
    my $data = { id => 1, hoge => [ {}, {} ], fuga => { a => [ {}, {} ] } };
    my $e = $pkg->new($data);
    $e->attr( [qw/hoge fuga/] );
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

subtest 'has_data' => sub {
    my $e = Yetie::Domain::Entity::Hoge->new( id => 1 );
    ok $e->has_data, 'right has data';

    $e = Yetie::Domain::Entity::Hoge->new();
    ok !$e->has_data, 'right has not data';
};

subtest 'is_empty' => sub {
    my $e = Yetie::Domain::Entity::Hoge->new( id => 1 );
    ok !$e->is_empty, 'right is not empty';

    $e = Yetie::Domain::Entity::Hoge->new();
    ok $e->is_empty, 'right is empty';
};

subtest 'to_array method' => sub {
    my $data = { id => 1, hoge => 1, fuga => 2 };
    my $e = $pkg->new($data);
    cmp_deeply $e->to_array, [ [qw/fuga hoge/], [qw/2 1/] ], 'right to_array';
};

subtest 'Entity object base' => sub {
    my $e1   = Yetie::Domain::Entity::Hoge->new( id => 1 );
    my $e1_1 = Yetie::Domain::Entity::Hoge->new( id => 1 );
    my $e2   = Yetie::Domain::Entity::Fuga->new( id => 2 );

    is $e1->id, 1, 'right entity id';
    is $e1->equal($e1_1), 1, 'right equal object';
    is $e1->equal($e2),   0, 'right not equal object';
    is $e1->hash_code, '356a192b7913b04c54574d18c28d46e6395428ab', 'right hash code';

    $e1->id(1);
    is $e1->is_modified, 0, 'right not modified';
    $e1->id(111);
    is $e1->is_modified, 1, 'right modified';

    is Yetie::Domain::Entity::Hoge->new->id, undef, 'right no data entity';
};

subtest 'to_data method' => sub {
    $pkg->attr( [qw(a b h h1 h2)] );

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

subtest 'is_modified' => sub {
    my $make_entity = sub {
        $pkg->attr( [qw(c d e f g x y z)] );

        my $e = $pkg->new(
            a => 1,
            b => 1,
            e => $pkg->new( x => 1 ),
            c => collection( $pkg->new( y => 1 ), $pkg->new( e => $pkg->new( z => 1 ) ) ),
            d => ix_hash( aa => $pkg->new( f => 1, g => 1 ) ),
        );
        return $e;
    };
    my $e;

    $e = $make_entity->();
    is $e->is_modified, 0;

    $e->{b} = 2;    # bad setter
    is $e->is_modified, 0;

    $e->a(2);
    is $e->is_modified, 1;

    # Entity
    subtest 'has entity' => sub {
        $e = $make_entity->();
        $e->e->x(2);
        is $e->is_modified, 1;

        # reset modified
        $e->reset_modified;
        is $e->is_modified, 0;
    };

    # Collection
    subtest 'has collection' => sub {
        $e = $make_entity->();
        $e->c->[0]->y(2);
        is $e->is_modified, 1;

        $e = $make_entity->();
        $e->c->[1]->e->z(2);
        is $e->is_modified, 1;

        # reset modified
        $e->reset_modified;
        is $e->is_modified, 0;
    };

    # IxHash
    subtest 'has IxHash' => sub {
        $e = $make_entity->();
        $e->d->aa->f(2);
        is $e->is_modified, 1;

        $e = $make_entity->();
        $e->d->aa->g(2);
        is $e->is_modified, 1;

        # reset modified
        $e->reset_modified;
        is $e->is_modified, 0;
    };
};

done_testing();

{

    package Yetie::Domain::Entity::Hoge;
    use Yetie::Domain::Entity;
}
{

    package Yetie::Domain::Entity::Fuga;
    use Yetie::Domain::Entity;
}
