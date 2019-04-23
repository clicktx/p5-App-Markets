use Mojo::Base -strict;
use Test::More;

my $pkg = 'Yetie::Domain::Value::Email';
use_ok $pkg;

subtest 'basic' => sub {
    my $v = $pkg->new( value => 'a@b.c' );
    is $v->value,       'a@b.c', 'right value';
    is $v->in_storage,  0,       'right in storage';
    is $v->is_primary,  0,       'right primary';
    is $v->is_verified, 0,       'right verified';
};

subtest 'to_data' => sub {
    my $v = $pkg->new();

    is_deeply $v->to_data,
      {
        _in_storage => 0,
        is_primary  => 0,
        is_verified => 0,
        value       => '',
      },
      'right dump data';
};

done_testing();
