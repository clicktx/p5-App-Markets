use Mojo::Base -strict;
use Test::More;
use t::Util;

use_ok 'Markets::Form::FieldSet';

use Markets::Form::Type::Test;
my $fs = Markets::Form::Type::Test->new;

# subtest 'each' => sub {
#     my @keys;
#     $fs->each( sub { push @keys, $a; isa_ok $b, 'Markets::Form::Field'; } );
#     is_deeply \@keys, [qw/email name address item.[].id/], 'right each keys';
# };

subtest 'attributes' => sub {
    ok( $fs->can($_), "right $_" ) for qw(controller params field_list);
};

subtest 'c' => sub {
    ok $fs->can('c');
    isa_ok $fs->c( 1, 2, 3 ), 'Mojo::Collection';
};

subtest 'field' => sub {
    my $f = $fs->field('email');
    isa_ok $f, 'Markets::Form::Field';
};

subtest 'keys' => sub {
    my @keys = $fs->keys;
    is_deeply \@keys, [qw/email name address item.[].id/], 'right keys';
    my $keys = $fs->keys;
    is ref $keys, 'ARRAY', 'right scalar';
};

subtest 'params' => sub {
    isa_ok $fs->params, 'Mojo::Parameters';
    $fs->params->append( email => 'a@b.com' );

    is $fs->params->param('email'), 'a@b.com', 'right get param';
    is $fs->params->param('a'),     undef,     'right empty param';
};

subtest 'render tags' => sub {
    is ref $fs->render('email'),       'CODE', 'right render method';
    is ref $fs->render_label('email'), 'CODE', 'right render_label method';
};

# This test should be done at the end!
subtest 'append/remove' => sub {
    $fs->append( aaa => ( type => 'text' ) );
    my @keys = $fs->keys;
    is_deeply \@keys, [qw/email name address item.[].id aaa/], 'right keys';

    $fs->remove('name');
    @keys = $fs->keys;
    is_deeply \@keys, [qw/email address item.[].id aaa/], 'right keys';
};

done_testing();
