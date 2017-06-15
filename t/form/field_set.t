use Mojo::Base -strict;
use Test::More;
use t::Util;

use_ok 'Markets::Form::FieldSet';

use Markets::Form::Test;
my $fs = Markets::Form::Test->new;

subtest 'each' => sub {
    my @keys;
    $fs->each( sub { push @keys, $a; isa_ok $b, 'Markets::Form::Field'; } );
    is_deeply \@keys, [qw/aaa item.[].id bbb ccc/], 'right each keys';
};

subtest 'field' => sub {
    my $f = $fs->field('aaa');
    isa_ok $f, 'Markets::Form::Field';
};

subtest 'keys' => sub {
    my @keys = $fs->keys;
    is_deeply \@keys, [qw/aaa item.[].id bbb ccc/], 'right keys';
};

done_testing();
