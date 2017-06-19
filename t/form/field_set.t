use Mojo::Base -strict;
use Test::More;
use t::Util;

use_ok 'Markets::Form::FieldSet';

use Markets::Form::Type::Test;
my $fs = Markets::Form::Type::Test->new;

# subtest 'each' => sub {
#     my @keys;
#     $fs->each( sub { push @keys, $a; isa_ok $b, 'Markets::Form::Field'; } );
#     is_deeply \@keys, [qw/email item.[].id name address/], 'right each keys';
# };

subtest 'field' => sub {
    my $f = $fs->field('email');
    isa_ok $f, 'Markets::Form::Field';
};

subtest 'keys' => sub {
    my @keys = $fs->keys;
    is_deeply \@keys, [qw/email item.[].id name address/], 'right keys';
};

subtest 'append/remove' => sub {
    $fs->append( aaa => ( type => 'text' ) );
    my @keys = $fs->keys;
    is_deeply \@keys, [qw/email item.[].id name address aaa/], 'right keys';

    $fs->remove('name');
    @keys = $fs->keys;
    is_deeply \@keys, [qw/email item.[].id address aaa/], 'right keys';
};

subtest 'params' => sub {
    isa_ok $fs->params, 'Mojo::Parameters';
    $fs->params->append( email => 'a@b.com' );

    is $fs->params->param('email'), 'a@b.com', 'right get param';
    is $fs->params->param('a'),     undef,     'right empty param';
};

done_testing();
