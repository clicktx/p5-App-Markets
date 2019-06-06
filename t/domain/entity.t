use Mojo::Base -strict;
use Test::More;
use Test::Deep;
use Yetie::Domain::Collection qw/collection/;
use Yetie::Domain::IxHash qw/ixhash/;
use Yetie::Domain::Value;
use Mojo::URL;

my $pkg = 'Yetie::Domain::Entity';
use_ok $pkg;

{

    package t::entity::foo;
    use Moose;
    extends 'Yetie::Domain::Entity';

    has [qw(hoge fuga)] => ( is => 'rw', default => 1 );
}

subtest 'basic' => sub {
    my $e = t::entity::foo->new( id => 1, hoge => 1, fuga => 2 );
    cmp_deeply $e->to_hash, { id => 1, hoge => 1, fuga => 2 }, 'right to_hash';

    $e->id(1);
    is $e->is_modified, 0, 'right not modified of update attribute but no change value';
    $e->id(111);
    is $e->is_modified, 1, 'right modified of update attribute';

    $e = t::entity::foo->new( id => 1, hoge => 1, fuga => 2 );
    $e->hoge(111);
    is $e->is_modified, 1, 'right modified of update attribute';

    $e = t::entity::foo->new( id => undef, hoge => undef, fuga => undef );
    cmp_deeply $e->to_hash, { hoge => 1, fuga => 1 }, 'right default not undef';
};

subtest 'factory' => sub {
    my $e = $pkg->new();
    my $f = $pkg->factory('entity-foo');
    isa_ok $f, 'Yetie::Factory';
};

subtest 'function' => sub {
    my $c = collection( 1, 2, 3 );
    isa_ok $c, 'Yetie::Domain::Collection';
    is_deeply $c, [ 1, 2, 3 ], 'right deeply';

    my $h = ixhash( a => 1, b => 2 );
    isa_ok $h, 'Yetie::Domain::IxHash';
    is_deeply $h, { a => 1, b => 2 }, 'right deeply';
};

subtest 'clone' => sub {
    my $data = { id => 1, hoge => [ {}, {} ], fuga => { a => [ {}, {} ] } };
    my $e = t::entity::foo->new($data);
    $e->id(2);

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

subtest 'has_id' => sub {
    my $e = t::entity::foo->new( id => 1 );
    ok $e->has_id, 'right has data';

    $e = t::entity::foo->new();
    ok !$e->has_id, 'right has not data';
};

subtest 'is_empty' => sub {
    my $e = t::entity::foo->new( id => 1 );
    ok !$e->is_empty, 'right is not empty';

    $e = t::entity::foo->new();
    ok $e->is_empty, 'right is empty';
};

subtest 'to_array method' => sub {
    my $data = { id => 1, hoge => 1, fuga => 2 };
    my $e = t::entity::foo->new($data);
    cmp_deeply $e->to_array, [ [qw/fuga hoge id/], [qw/2 1 1/] ], 'right to_array';
};

{

    package t::entity::bar;
    use Moose;
    extends 'Yetie::Domain::Entity';

    has [qw(hoge fuga)] => ( is => 'rw' );
}
subtest 'Entity object base' => sub {
    my $e1   = t::entity::foo->new( id => 1 );
    my $e1_1 = t::entity::foo->new( id => 1 );
    my $e2   = t::entity::bar->new( id => 2 );

    is $e1->id, 1, 'right entity id';
    is $e1->equals($e1_1), 1, 'right equals object';
    is $e1->equals($e2),   0, 'right not equals object';
    is $e1->hash_code, '6ca65f8d83d4a82d0a13787b073002e08551ee49', 'right hash code';

    $e1->id(1);
    is $e1->is_modified, 0, 'right not modified';
    $e1->id(111);
    is $e1->is_modified, 1, 'right modified';

    my $obj = t::entity::foo->new;
    is $obj->id, undef, 'right no data entity';
};

subtest 'to_data method' => sub {
    {

        package t::entity::to_data;
        use Moose;
        extends 'Yetie::Domain::Entity';

        has [qw(a b h1 h2 h3 url v)] => ( is => 'rw' );
    }
    my $e = t::entity::to_data->new(
        a  => 1,
        b  => 2,
        h2 => t::entity::to_data->new(),
        h3 => t::entity::to_data->new(
            a  => 1,
            h1 => t::entity::to_data->new( a => 1, b => 2 ),
        ),
        url => Mojo::URL->new,                                # has not "to_data" method.
        v   => Yetie::Domain::Value->new( value => 'foo' ),
    );

    cmp_deeply $e->to_data,
      {
        a  => 1,
        b  => 2,
        h2 => {},
        h3 => {
            a  => 1,
            h1 => {
                a => 1,
                b => 2
            },
        },
        v => 'foo',
      },
      'right dump data';
};

subtest 'is_modified' => sub {
    {

        package t::entity::modified;
        use Moose;
        extends 'Yetie::Domain::Entity';

        has [qw(a b c d e f g x y z)] => ( is => 'rw' );
    }
    my $make_entity = sub {
        my $e = t::entity::modified->new(
            a => 1,
            b => 1,
            e => t::entity::modified->new( x => 1 ),
            c => collection(
                t::entity::modified->new( y => 1 ),
                t::entity::modified->new( e => t::entity::modified->new( z => 1 ) )
            ),
            d => ixhash( aa => t::entity::modified->new( f => 1, g => 1 ) ),
        );
        return $e;
    };

    my $e = $make_entity->();
    is $e->is_modified, 0;
    $e->{b} = 2;    # bad setter
    is $e->is_modified, 1;

    $e = $make_entity->();
    $e->a(2);
    is $e->is_modified, 1;

    # Entity
    subtest 'has entity' => sub {
        $e = $make_entity->();
        $e->e->x(2);
        is $e->is_modified, 1;
    };

    # Collection
    subtest 'has collection' => sub {
        $e = $make_entity->();
        $e->c->[0]->y(2);
        is $e->is_modified, 1;

        $e = $make_entity->();
        $e->c->[1]->e->z(2);
        is $e->is_modified, 1;
    };

    # IxHash
    subtest 'has IxHash' => sub {
        $e = $make_entity->();
        $e->d->aa->f(2);
        is $e->is_modified, 1;

        $e = $make_entity->();
        $e->d->aa->g(2);
        is $e->is_modified, 1;
    };
};

done_testing();
