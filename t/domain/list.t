use Mojo::Base -strict;
use Test::More;
use Yetie::Domain::Collection qw(c);

my $pkg = 'Yetie::Domain::List';
use_ok $pkg;

my $construct = sub {
    my $list = c(@_);
    $pkg->new( list => $list );
};

subtest 'basic' => sub {
    my $v = $pkg->new();
    isa_ok $v->list, 'Yetie::Domain::Collection', 'right attribute list';
    can_ok $v, (qw(each find first last push reduce size));
};

subtest 'get' => sub {
    my $v = $construct->( 1, 2, 3 );
    is $v->get(1), 2,     'right get element';
    is $v->get(4), undef, 'right has not element';
};

subtest 'to_data' => sub {
    my $v = $construct->( 1, 2, 3 );
    is_deeply $v->to_data, [ 1, 2, 3 ], 'right dump data';
};

done_testing();
