use Mojo::Base -strict;
use Test::More;

my $pkg = 'Yetie::Domain::Value::Email';
use_ok $pkg;

subtest 'basic' => sub {
    my $v = $pkg->new(
        value      => 'a@b.c',
        is_primary => 0,
    );
    is $v->value,      'a@b.c', 'right value';
    is $v->is_primary, 0,       'right primary';
};

done_testing();
